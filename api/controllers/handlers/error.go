package handlers

import (
	"api/constants"
	"errors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"log"
	"net/http"
)

type AppError struct {
	Code    int
	Type    string
	Message string
	Details map[string]interface{}
}

func (e AppError) WithAdditional(data map[string]interface{}) AppError {
	e.Details = data
	return e
}

var (
	InternalServerError    = AppError{500, "InternalServerError", "Internal server error", nil}
	Unauthorized           = AppError{401, "Unauthorized", "Unauthorized", nil}
	InvalidRequest         = AppError{400, "InvalidRequest", "Invalid request data", nil}
	InvalidBirthday        = AppError{400, "InvalidBirthday", "Invalid birthday format, use DD.MM.YYYY", nil}
	InvalidPassword        = AppError{400, "InvalidPassword", "Invalid password", nil}
	InvalidCode            = AppError{400, "InvalidCode", "Invalid code", nil}
	DataNotFound           = AppError{404, "DataNotFound", "Data not found", nil}
	RegionNotFound         = AppError{404, "RegionNotFound", "Region not found", nil}
	UserNotFound           = AppError{404, "UserNotFound", "User with this email not found", nil}
	CodeNotFoundOrExpired  = AppError{404, "CodeNotFoundOrExpired", "Code not found or expired", nil}
	NotEnoughRights        = AppError{403, "NotEnoughRights", "User does not have enough rights", nil}
	UserNotAdmin           = AppError{403, "UserNotAdmin", "User is not an administrator", nil}
	TooManyAttempts        = AppError{429, "TooManyAttempts", "Too many attempts", nil}
	PreviousCodeNotExpired = AppError{400, "PreviousCodeNotExpired", "Please wait until the previous code expires", nil}
)

var KnownErrors = map[error]string{
	gorm.ErrRecordNotFound: constants.DataNotFound,
}

func HandleErrorWithCode(c *gin.Context, appError AppError) {
	c.JSON(appError.Code, gin.H{"message": appError.Message, "type": appError.Type})
}

func HandleError(c *gin.Context, err error) {
	var errorMessage string
	var statusCode int

	for knownErr, message := range KnownErrors {
		if errors.Is(err, knownErr) {
			errorMessage = message
			break
		}
	}
	if errorMessage == "" {
		errorMessage = constants.InternalServerError
		statusCode = http.StatusInternalServerError
		log.Printf("Internal Server Error: %v", err)
	} else {
		switch errorMessage {
		case constants.DataNotFound:
			statusCode = http.StatusNotFound
		case constants.Unauthorized:
			statusCode = http.StatusUnauthorized
		case constants.InvalidRequest:
			statusCode = http.StatusBadRequest
		default:
			statusCode = http.StatusInternalServerError
		}
	}

	c.JSON(statusCode, gin.H{"error": errorMessage})
}
