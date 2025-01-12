package controllers

import (
	"api/constants"
	"api/db"
	"context"
	"errors"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/go-redis/redis/v8"
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

func SendCode(c *gin.Context) {
	var request SendRequest
	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	code := GenerateCode()

	// собственно отправка email и кода через брокер сообщений в python
	fmt.Printf("Code %s sent to %s", code, request.Email)

	err := db.Redis.Set(ctx, request.Email, code, constants.EMAIL_CODE_TTL*time.Minute).Err()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Код отправлен на " + request.Email})
}

func VerifyCode(c *gin.Context) {
	var request VerifyRequest
	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	}

	storedCode, err := db.Redis.Get(ctx, request.Email).Result()
	if errors.Is(err, redis.Nil) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Код не найден или истёк"})
		return
	} else if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при подключении к Redis"})
		return
	}

	if storedCode != request.Code {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Неверный код"})
		return
	}

	err = db.Redis.Del(ctx, request.Email).Err()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Ошибка при удалении кода из Redis"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Email успешно подтверждён"})
}

func GenerateCode() string {
	code := fmt.Sprintf("%04d", rand.Intn(10000))
	return code
}
