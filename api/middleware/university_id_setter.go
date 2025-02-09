package middleware

import (
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
)

func (mw *Mw) UniversityIdSetter() gin.HandlerFunc {
	return func(c *gin.Context) {
		session := sessions.Default(c)
		session.Set("university_id", c.Param("id"))
		c.Next()
	}
}
