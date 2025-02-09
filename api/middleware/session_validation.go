package middleware

import (
	"api/utils/constants"
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
)

func (mw *Mw) SessionMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		session := sessions.Default(c)
		userID := session.Get(constants.ContextUserID)
		if userID != nil {
			uintUserID, ok := userID.(uint)
			if ok {
				c.Set(constants.ContextUserID, uintUserID)
			}
		}
		c.Next()
	}
}
