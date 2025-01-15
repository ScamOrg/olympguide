package middleware

import (
	"api/constants"
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
	"net/http"
)

func SessionMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		session := sessions.Default(c)
		userID := session.Get("user_id")
		if userID == nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": constants.Unauthorized})
			c.Abort()
			return
		}
		c.Set("user_id", userID)
		c.Next()
	}
}
