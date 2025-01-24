package auth

import (
	"api/constants"
	"api/controllers/auth/api"
	"api/controllers/handlers"
	"api/logic"
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
	"net/http"
	"time"
)

type LoginRequest struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

func SignUp(c *gin.Context) {
	var request api.SignUpRequest
	if err := c.ShouldBind(&request); err != nil {
		handlers.HandleErrorWithCode(c, http.StatusBadRequest, constants.InvalidRequest)
		return
	}
	parsedBirthday, err := time.Parse("02.01.2006", request.Birthday)
	if err != nil {
		handlers.HandleErrorWithCode(c, http.StatusBadRequest, constants.InvalidBirthday)
		return
	}

	regionExists := logic.IsRegionExists(request.RegionID)
	if !regionExists {
		handlers.HandleErrorWithCode(c, http.StatusBadRequest, constants.RegionNotFound)
		return
	}

	hashedPassword, err := hashPassword(request.Password)
	if err != nil {
		handlers.HandleError(c, err)
		return
	}
	user := api.CreateUserFromRequest(request, parsedBirthday, hashedPassword)
	_, err = logic.CreateUser(&user)
	if err != nil {
		handlers.HandleError(c, err)
		return
	}
	c.JSON(http.StatusCreated, gin.H{"message": "Signed up"})
}

func Login(c *gin.Context) {
	var request LoginRequest
	if err := c.ShouldBind(&request); err != nil {
		handlers.HandleErrorWithCode(c, http.StatusBadRequest, constants.InvalidRequest)
		return
	}

	user, err := logic.GetUserByEmail(request.Email)
	if err != nil {
		handlers.HandleErrorWithCode(c, http.StatusUnauthorized, constants.UserNotFound)
		return
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(request.Password)); err != nil {
		handlers.HandleErrorWithCode(c, http.StatusUnauthorized, constants.InvalidPassword)
		return
	}

	session := sessions.Default(c)
	session.Set("user_id", user.UserID)
	if err := session.Save(); err != nil {
		handlers.HandleError(c, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Logged in", "user_id": user.UserID})
}

func Logout(c *gin.Context) {
	session := sessions.Default(c)
	session.Clear()
	err := session.Save()
	if err != nil {
		handlers.HandleError(c, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Logged out"})
}

func hashPassword(password string) (string, error) {
	hashedBytes, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return "", err
	}
	return string(hashedBytes), nil
}
