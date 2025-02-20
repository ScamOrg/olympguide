package errs

import (
	"errors"
	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5/pgconn"
	"gorm.io/gorm"
	"log"
)

// AppError представляет стандартную структуру ошибки API.
//
// @Description Структура ошибки, возвращаемая API в случае неудачного запроса.
type AppError struct {
	Code    int                    `json:"code" example:"400"`                     // HTTP-код ошибки
	Type    string                 `json:"type" example:"InvalidRequest"`          // Тип ошибки
	Message string                 `json:"message" example:"Invalid request data"` // Сообщение об ошибке
	Details map[string]interface{} `json:"details,omitempty"`                      // Дополнительные сведения об ошибке (если есть)
}

var (
	InternalServerError = AppError{500, "InternalServerError", "Internal server error", nil}
	Unauthorized        = AppError{401, "Unauthorized", "Unauthorized", nil}
	NotEnoughRights     = AppError{403, "NotEnoughRights", "User does not haves enough rights", nil}
)
var (
	CodeNotFoundOrExpired  = AppError{404, "CodeNotFoundOrExpired", "Code not found or expired", nil}
	TooManyAttempts        = AppError{429, "TooManyAttempts", "Too many attempts", nil}
	PreviousCodeNotExpired = AppError{400, "PreviousCodeNotExpired", "Please wait until the previous code expires", nil}
)

var (
	InvalidRequest  = AppError{400, "InvalidRequest", "Invalid request data", nil}
	InvalidBirthday = AppError{400, "InvalidBirthday", "Invalid birthday format, use DD.MM.YYYY", nil}
	InvalidPassword = AppError{400, "InvalidPassword", "Invalid password", nil}
	InvalidCode     = AppError{400, "InvalidCode", "Invalid code", nil}
	InvalidID       = AppError{400, "InvalidID", "Invalid id", nil}
)

var (
	DataNotFound   = AppError{404, "DataNotFound", "Data not found", nil}
	RegionNotFound = AppError{404, "RegionNotFound", "Region not found", nil}
	UserNotFound   = AppError{404, "UserNotFound", "User with this email not found", nil}
)

var (
	FacultyNotInUniversity = AppError{
		Code:    400,
		Type:    "FacultyNotInUniversity",
		Message: "The specified faculty does not exist or does not belong to the given university",
	}
)

var (
	ForeignKeyViolation = AppError{400, "ForeignKeyViolation", "Foreign key violation", nil}
	UniqueViolation     = AppError{409, "UniqueViolation", "Unique constraint violation", nil}
)

func (e AppError) WithAdditional(data map[string]interface{}) AppError {
	newError := e
	newError.Details = data
	return newError
}

func (e AppError) Error() string {
	return e.Message
}

func HandleError(c *gin.Context, err error) {
	var appErr AppError
	if errors.As(err, &appErr) {
		handleAppError(c, appErr)
	} else {
		handleUnknownError(c, err)
	}
}

func handleAppError(c *gin.Context, appError AppError) {
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

func handleUnknownError(c *gin.Context, err error) {
	var resultError *AppError = nil
	for knownErr, appErr := range KnownErrors {
		if errors.Is(err, knownErr) {
			resultError = &appErr
			break
		}
	}
	var pgErr *pgconn.PgError
	if errors.As(err, &pgErr) {
		switch pgErr.Code {
		case "23505":
			resultError = &UniqueViolation
		case "23503":
			resultError = &ForeignKeyViolation
		}
	}
	if resultError == nil {
		resultError = &InternalServerError
		log.Printf("Internal Server Error: %v", err)
	}
	handleAppError(c, *resultError)
}
