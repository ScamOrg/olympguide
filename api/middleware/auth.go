package middleware

import (
	"api/constants"
	"github.com/gin-gonic/gin"
	"net/http"
)

func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		_, exist := c.Get("user_id")
		if exist == false {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": constants.Unauthorized})
			return
		}
		c.Next()
	}
}
