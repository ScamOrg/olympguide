package middleware

import (
	"api/utils/errs"
	"github.com/gin-gonic/gin"
	"strconv"
)

func (mw *Mw) ValidateID() gin.HandlerFunc {
	return func(c *gin.Context) {
		id := c.Param("id")
		if _, err := strconv.Atoi(id); id != "" && err != nil {
			errs.HandleError(c, errs.InvalidID)
			c.Abort()
			return
		}
		c.Next()
	}
}
