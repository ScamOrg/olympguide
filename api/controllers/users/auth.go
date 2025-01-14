package users

import (
	"api/db"
	"api/models"
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
	"log"
	"net/http"
	"time"
)

type SignUpRequest struct {
	Email      string `json:"email" binding:"required"`
	Password   string `json:"password" binding:"required"`
	FirstName  string `json:"first_name" binding:"required"`
	LastName   string `json:"last_name" binding:"required"`
	SecondName string `json:"second_name" binding:"omitempty,min=1"`
	Birthday   string `json:"birthday" binding:"required"`
	RegionID   uint   `json:"region_id" binding:"required"`
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

func SignUp(c *gin.Context) {
	var request SignUpRequest
	if err := c.ShouldBind(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	parsedBirthday, err := time.Parse("02.01.2006", request.Birthday)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid birthday format, use DD.MM.YYYY"}) // Возвращаем ошибку, если формат неверный
		return
	}

	var regionExists bool
	db.DB.Raw("SELECT EXISTS(SELECT 1 FROM olympguide.region WHERE region_id = ?)", request.RegionID).Scan(&regionExists)
	if !regionExists {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Region does not exist"})
		return
	}

	hashedPassword, err := HashPassword(request.Password)
	if err != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Internal error"})
	}
	user := models.User{
		Email:        request.Email,
		FirstName:    request.FirstName,
		LastName:     request.LastName,
		SecondName:   request.SecondName,
		Birthday:     parsedBirthday,
		PasswordHash: hashedPassword,
		RegionID:     request.RegionID,
	}
	result := db.DB.Create(&user)
	if result.Error != nil {
		log.Println(err)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Internal error"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Signed up", "user_id": user.UserID})
}

func Login(c *gin.Context) {
	var request LoginRequest
	if err := c.ShouldBind(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Email and password are required"})
		return
	}

	var user models.User
	if err := db.DB.Where("email = ?", request.Email).First(&user).Error; err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "There is no user with this email"})
		return
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(request.Password)); err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Wrong password"})
		return
	}

	session := sessions.Default(c)
	session.Set("user_id", user.UserID)
	if err := session.Save(); err != nil {
		log.Println(err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Internal error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Logged in", "user_id": user.UserID})
}

func Logout(c *gin.Context) {
	session := sessions.Default(c)
	session.Clear()
	err := session.Save()
	if err != nil {
		log.Println(err.Error())
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
