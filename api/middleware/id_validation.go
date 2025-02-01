package middleware

import (
	"api/controllers/handlers"
	"github.com/gin-gonic/gin"
	"strconv"
)

func ValidateID() gin.HandlerFunc {
	return func(c *gin.Context) {
		fieldID := c.Param("id")
		if _, err := strconv.Atoi(fieldID); fieldID != "" && err != nil {
			handlers.HandleAppError(c, handlers.InvalidID)
			c.Abort()
			return
		}
		c.Next()
	}
}
