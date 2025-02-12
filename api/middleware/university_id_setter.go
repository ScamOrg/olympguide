package middleware

import (
	"api/utils/constants"
	"github.com/gin-gonic/gin"
	"strconv"
)

func (mw *Mw) UniversityIdSetter() gin.HandlerFunc {
	return func(c *gin.Context) {
		intID, _ := strconv.Atoi(c.Param("id"))
		c.Set(constants.ContextUniverID, uint(intID))
		c.Next()
	}
}
