package middleware

import (
	"api/handler/errors"
	"github.com/gin-gonic/gin"
	"strconv"
)

func ValidateID() gin.HandlerFunc {
	return func(c *gin.Context) {
		fieldID := c.Param("id")
		if _, err := strconv.Atoi(fieldID); fieldID != "" && err != nil {
			err.HandleAppError(c, err.InvalidID)
			c.Abort()
			return
		}
		c.Next()
	}
}
