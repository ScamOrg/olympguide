package errs

import (
	"errors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"log"
)

type AppError struct {
	Code    int
	Type    string
	Message string
	Details map[string]interface{}
}

var (
	InternalServerError    = AppError{500, "InternalServerError", "Internal server errs", nil}
	Unauthorized           = AppError{401, "Unauthorized", "Unauthorized", nil}
	InvalidRequest         = AppError{400, "InvalidRequest", "Invalid request data", nil}
	InvalidBirthday        = AppError{400, "InvalidBirthday", "Invalid birthday format, use DD.MM.YYYY", nil}
	InvalidPassword        = AppError{400, "InvalidPassword", "Invalid password", nil}
	InvalidCode            = AppError{400, "InvalidCode", "Invalid code", nil}
	InvalidID              = AppError{400, "InvalidID", "Invalid id", nil}
	DataNotFound           = AppError{404, "DataNotFound", "Data not found", nil}
	RegionNotFound         = AppError{404, "RegionNotFound", "Region not found", nil}
	UserNotFound           = AppError{404, "UserNotFound", "User with this email not found", nil}
	CodeNotFoundOrExpired  = AppError{404, "CodeNotFoundOrExpired", "Code not found or expired", nil}
	NotEnoughRights        = AppError{403, "NotEnoughRights", "User does not have enough rights", nil}
	UserNotAdmin           = AppError{403, "UserNotAdmin", "User is not an administrator", nil}
	TooManyAttempts        = AppError{429, "TooManyAttempts", "Too many attempts", nil}
	PreviousCodeNotExpired = AppError{400, "PreviousCodeNotExpired", "Please wait until the previous code expires", nil}
)

func (e AppError) WithAdditional(data map[string]interface{}) AppError {
	newError := e
	newError.Details = data
	return newError
}

func (e AppError) Error() string {
	return e.Message
}

func HandleAppError(c *gin.Context, appError AppError) {
	response := gin.H{
		"message": appError.Message,
		"type":    appError.Type,
	}
	if appError.Details != nil {
		for k, v := range appError.Details {
			response[k] = v
		}
	}
	c.JSON(appError.Code, response)
}

var KnownErrors = map[error]AppError{
	gorm.ErrRecordNotFound: DataNotFound,
}

func HandleUnknownError(c *gin.Context, err error) {
	var resultError *AppError = nil
	for knownErr, appErr := range KnownErrors {
		if errors.Is(err, knownErr) {
			resultError = &appErr
			break
		}
	}
	if resultError == nil {
		resultError = &InternalServerError
		log.Printf("Internal Server Error: %v", err)
	}
	HandleAppError(c, *resultError)
}
