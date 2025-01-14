package controllers

import (
	"api/constants"
	"api/db"
	"api/models"
	"context"
	"errors"
	"fmt"
	"github.com/gin-gonic/gin"
	"github.com/go-redis/redis/v8"
	"golang.org/x/crypto/bcrypt"
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

type SignUpRequest struct {
	Email      string    `json:"email" binding:"required"`
	Password   string    `json:"password" binding:"required"`
	FirstName  string    `json:"first_name" binding:"required"`
	LastName   string    `json:"last_name" binding:"required"`
	SecondName string    `json:"second_name" binding:"omitempty,min=1"`
	Birthday   time.Time `json:"birthday" binding:"required"`
	RegionID   string    `json:"region_id"`
}

type Message struct {
	Email string `json:"email"`
	Code  string `json:"code"`
}

func SendCode(c *gin.Context) {
	var request SendRequest
	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	code := GenerateCode()

	err := db.Redis.Set(ctx, request.Email, code, constants.EMAIL_CODE_TTL*time.Minute).Err()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}

	msg := Message{request.Email, code}
	err = db.Redis.Publish(ctx, "email_codes", msg).Err()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal error"})
		return
	}
	log.Printf("Code %s sent to %s", code, request.Email)

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
	db.Redis.Del(ctx, request.Email)
	c.JSON(http.StatusOK, gin.H{"message": "Email успешно подтверждён"})
}

func GenerateCode() string {
	code := fmt.Sprintf("%04d", rand.Intn(10000))
	return code
}

func SignUp(c *gin.Context) {
	var request SignUpRequest
	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	hashedPassword, err := HashPassword(request.Password)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
	}
	user := models.User{
		Email:        request.Email,
		FirstName:    request.FirstName,
		LastName:     request.LastName,
		SecondName:   request.SecondName,
		Birthday:     request.Birthday,
		PasswordHash: hashedPassword,
	}
	result := db.DB.Create(&user)
	if result.Error != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": result.Error.Error()})
		return
	}
	c.JSON(http.StatusOK, gin.H{"user_id": user.UserID})
}

func HashPassword(password string) (string, error) {
	hashedBytes, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return "", err
	}
	return string(hashedBytes), nil
}
