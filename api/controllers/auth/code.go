package auth

import (
	"api/controllers/auth/api"
	"api/controllers/handlers"
	"api/logic"
	"context"
	"fmt"
	"github.com/gin-gonic/gin"
	"log"
	"math/rand"
	"net/http"
	"strconv"
)

var ctx = context.Background()

func SendCode(c *gin.Context) {
	var request api.SendRequest
	if err := c.ShouldBind(&request); err != nil {
		handlers.HandleAppError(c, handlers.InvalidRequest)
		return
	}

	isSent, time, err := logic.IsCodeAlreadySent(ctx, request.Email)
	if err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}
	if isSent {
		details := map[string]interface{}{"time": time.Seconds()}
		err := handlers.PreviousCodeNotExpired.WithAdditional(details)
		handlers.HandleAppError(c, err)
		return
	}
	code := GenerateCode()

	if err := logic.SaveCodeToRedis(ctx, request.Email, code); err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}

	if err := logic.SendCodeViaPubSub(ctx, request.Email, code); err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}

	log.Printf("Code %s sent to %s", code, request.Email)
	c.JSON(http.StatusOK, gin.H{"message": "Code sent to " + request.Email})
}

func VerifyCode(c *gin.Context) {
	var request api.VerifyRequest
	if err := c.ShouldBind(&request); err != nil {
		handlers.HandleAppError(c, handlers.InvalidRequest)
		return
	}

	result, err := logic.GetCodeAndAttempts(ctx, request.Email)
	if err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}

	if len(result) == 0 {
		handlers.HandleAppError(c, handlers.CodeNotFoundOrExpired)
		return
	}

	storedCode := result["code"]
	attempts, _ := strconv.Atoi(result["attempts"])

	if attempts > main.MaxVerifyCodeAttempts {
		handlers.HandleAppError(c, handlers.TooManyAttempts)
		return
	}

	if storedCode != request.Code {
		if err := logic.IncrementAttempts(ctx, request.Email); err != nil {
			handlers.HandleUnknownError(c, err)
			return
		}
		handlers.HandleAppError(c, handlers.InvalidCode)
		return
	}

	if err := logic.DeleteCode(ctx, request.Email); err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Email confirmed"})
}

func GenerateCode() string {
	code := fmt.Sprintf("%04d", rand.Intn(10000))
	return code
}
