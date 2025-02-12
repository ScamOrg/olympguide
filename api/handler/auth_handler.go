package handler

import (
	"api/dto"
	"api/service"
	"api/utils/constants"
	"api/utils/errs"
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
)

type AuthHandler struct {
	authService service.IAuthService
}

func NewAuthHandler(authService service.IAuthService) *AuthHandler {
	return &AuthHandler{authService: authService}
}

func (h *AuthHandler) SendCode(c *gin.Context) {
	var request dto.SendRequest
	if err := c.ShouldBind(&request); err != nil {
		errs.HandleError(c, errs.InvalidRequest)
		return
	}

	err := h.authService.SendCode(request.Email)

	if err != nil {
		errs.HandleError(c, err)
		return
	}

	log.Printf("Code to %s", request.Email)
	c.JSON(http.StatusOK, gin.H{"message": "Code sent to " + request.Email})
}

func (h *AuthHandler) VerifyCode(c *gin.Context) {
	var request dto.VerifyRequest
	if err := c.ShouldBind(&request); err != nil {
		errs.HandleError(c, errs.InvalidRequest)
		return
	}

	err := h.authService.VerifyCode(request.Email, request.Code)

	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Email confirmed"})
}

func (h *AuthHandler) SignUp(c *gin.Context) {
	var request dto.SignUpRequest
	if err := c.ShouldBind(&request); err != nil {
		errs.HandleError(c, errs.InvalidRequest)
		return
	}

	err := h.authService.SignUp(&request)

	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Signed up"})
}

func (h *AuthHandler) Login(c *gin.Context) {
	var request dto.LoginRequest
	if err := c.ShouldBind(&request); err != nil {
		errs.HandleError(c, errs.InvalidRequest)
		return
	}

	userID, err := h.authService.Login(request.Email, request.Password)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	session := sessions.Default(c)
	session.Set(constants.ContextUserID, userID)

	if err = session.Save(); err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Logged in"})
}

func (h *AuthHandler) Logout(c *gin.Context) {
	session := sessions.Default(c)
	session.Clear()
	if err := session.Save(); err != nil {
		errs.HandleError(c, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Logged out"})
}
