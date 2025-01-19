package auth

import (
	"api/constants"
	"api/db"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/go-redis/redis/v8"
	"log"
	"math/rand"
	"net/http"
	"time"
)

var ctx = context.Background()

type SendRequest struct {
	Email string `json:"email" binding:"required"`
}

type VerifyRequest struct {
	Email string `json:"email" binding:"required"`
	Code  string `json:"code" binding:"required"`
}

type Message struct {
	Email string `json:"email"`
	Code  string `json:"code"`
}

func SendCode(c *gin.Context) {
	var request SendRequest
	if err := c.ShouldBind(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": constants.InvalidRequest})
		return
	}
	code := GenerateCode()

	err := db.Redis.Set(ctx, request.Email, code, constants.EmailCodeTtl*time.Minute).Err()
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		return
	}

	msg := Message{request.Email, code}
	msgJSON, _ := json.Marshal(msg)
	err = db.Redis.Publish(ctx, "email_codes", msgJSON).Err()
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		return
	}
	log.Printf("Code %s sent to %s", code, request.Email)

	c.JSON(http.StatusOK, gin.H{"message": "Code sent to " + request.Email})
}

func VerifyCode(c *gin.Context) {
	var request VerifyRequest
	if err := c.ShouldBind(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": constants.InvalidRequest})
		return
	}

	storedCode, err := db.Redis.Get(ctx, request.Email).Result()
	if errors.Is(err, redis.Nil) {
		c.JSON(http.StatusBadRequest, gin.H{"error": constants.CodeNotFoundOrExpired})
		return
	} else if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		return
	}

	if storedCode != request.Code {
		c.JSON(http.StatusBadRequest, gin.H{"error": constants.InvalidCode})
		return
	}
	db.Redis.Del(ctx, request.Email)
	c.JSON(http.StatusOK, gin.H{"message": "Email confirmed"})
}

func GenerateCode() string {
	code := fmt.Sprintf("%04d", rand.Intn(10000))
	return code
}
