package handlers

import (
	"api/constants"
	"errors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"log"
	"net/http"
)

var KnownErrors = map[error]string{
	gorm.ErrRecordNotFound: constants.DataNotFound,
}

func HandleErrorWithDetails(c *gin.Context, statusCode int, errorMessage string, details map[string]interface{}) {
	response := gin.H{"error": errorMessage}
	for key, value := range details {
		response[key] = value
	}
	c.JSON(statusCode, response)
}

func HandleErrorWithCode(c *gin.Context, statusCode int, errorMessage string) {
	c.JSON(statusCode, gin.H{"error": errorMessage})
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
