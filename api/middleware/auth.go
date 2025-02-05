package middleware

import (
	"api/utils/errs"
	"github.com/gin-gonic/gin"
)

func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		_, exist := c.Get("user_id")
		if exist == false {
			errs.HandleError(c, errs.Unauthorized)
			c.Abort()
			return
		}
		c.Next()
	}
}
