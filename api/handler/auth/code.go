package auth

import (
	"api/errs"
	"api/handler/auth/transfer"
	"errors"
	"github.com/gin-gonic/gin"
	"log"
	"net/http"
)

func (h *Handler) SendCode(c *gin.Context) {
	var request transfer.SendRequest
	if err := c.ShouldBind(&request); err != nil {
		errs.HandleAppError(c, errs.InvalidRequest)
		return
	}

	err := h.codeService.SendCode(request.Email)

	if err != nil {
		var appErr errs.AppError
		if errors.As(err, &appErr) {
			errs.HandleAppError(c, appErr)
		} else {
			errs.HandleUnknownError(c, err)
		}
		return
	}

	log.Printf("Code to %s", request.Email)
	c.JSON(http.StatusOK, gin.H{"message": "Code sent to " + request.Email})
}

func (h *Handler) VerifyCode(c *gin.Context) {
	var request transfer.VerifyRequest
	if err := c.ShouldBind(&request); err != nil {
		errs.HandleAppError(c, errs.InvalidRequest)
		return
	}

	err := h.codeService.VerifyCode(request.Email, request.Code)

	if err != nil {
		var appErr errs.AppError
		if errors.As(err, &appErr) {
			errs.HandleAppError(c, appErr)
		} else {
			errs.HandleUnknownError(c, err)
		}
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Email confirmed"})
}
