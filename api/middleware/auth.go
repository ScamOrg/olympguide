package middleware

import (
	"api/controllers/handlers"
	"github.com/gin-gonic/gin"
)

func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		_, exist := c.Get("user_id")
		if exist == false {
			handlers.HandleAppError(c, handlers.Unauthorized)
			c.Abort()
			return
		}
		c.Next()
	}
}
