package controllers

import (
	"api/constants"
	"api/db"
	"api/models"
	"context"
	"errors"
	"fmt"
	"github.com/gin-contrib/sessions"
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

type LoginRequest struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type Message struct {
	Email string `json:"email"`
	Code  string `json:"code"`
}

func SendCode(c *gin.Context) {
	var request SendRequest
	if err := c.ShouldBind(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	code := GenerateCode()

	err := db.Redis.Set(ctx, request.Email, code, constants.EMAIL_CODE_TTL*time.Minute).Err()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Internal error"})
		return
	}

	msg := Message{request.Email, code}
	err = db.Redis.Publish(ctx, "email_codes", msg).Err()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Internal error"})
		return
	}
	log.Printf("Code %s sent to %s", code, request.Email)

	c.JSON(http.StatusOK, gin.H{"message": "Code sent to " + request.Email})
}

func VerifyCode(c *gin.Context) {
	var request VerifyRequest
	if err := c.ShouldBind(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
	}

	storedCode, err := db.Redis.Get(ctx, request.Email).Result()
	if errors.Is(err, redis.Nil) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Code was not found or expired"})
		return
	} else if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Internal error"})
		return
	}

	if storedCode != request.Code {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid code"})
		return
	}
	db.Redis.Del(ctx, request.Email)
	c.JSON(http.StatusOK, gin.H{"message": "Email confirmed"})
}

func GenerateCode() string {
	code := fmt.Sprintf("%04d", rand.Intn(10000))
	return code
}

func SignUp(c *gin.Context) {
	var request SignUpRequest
	if err := c.ShouldBind(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	hashedPassword, err := HashPassword(request.Password)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Internal error"})
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
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Internal error"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Registered", "user_id": user.UserID})
}

func Login(c *gin.Context) {
	var request LoginRequest
	if err := c.ShouldBind(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Email and password are required"})
		return
	}

	hashedPassword, err := HashPassword(request.Password)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Internal error"})
	}

	var user models.User
	if err := db.DB.Where("email = ? AND password_hash = ?", request.Email, hashedPassword).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
		return
	}

	session := sessions.Default(c)
	session.Set("user_id", user.UserID)
	if err := session.Save(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Logged in", "user_id": user.UserID})
}

func Logout(c *gin.Context) {
	session := sessions.Default(c)
	session.Clear()
	err := session.Save()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "error"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Logged out"})
}

func HashPassword(password string) (string, error) {
	hashedBytes, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return "", err
	}
	return string(hashedBytes), nil
}
