package middleware

import (
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
)

func SessionMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		session := sessions.Default(c)
		userID := session.Get("user_id")
		if userID != nil {
			uintUserID, ok := userID.(uint)
			if ok {
				c.Set("user_id", uintUserID)
			}
		}
		c.Next()
	}
}
