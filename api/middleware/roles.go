package middleware

import (
	"api/utils/constants"
	"api/utils/errs"
	"api/utils/role"
	"github.com/gin-gonic/gin"
	"os"
)

func (mw *Mw) RolesMiddleware(allowedRoles ...string) gin.HandlerFunc {
	return func(c *gin.Context) {
		bearerToken := c.GetHeader("Authorization")
		for _, allowedRole := range allowedRoles {
			if allowedRole == role.DataLoaderService && bearerToken == "Bearer "+os.Getenv("BEARER_DATA_LOADER_TOKEN") {
				c.Next()
				return
			}
		}

		userID, exists := c.Get(constants.ContextUserID)
		if !exists {
			errs.HandleError(c, errs.Unauthorized)
			c.Abort()
			return
		}

		var universityID uint
		if uniID, ok := c.Get(constants.ContextUniverID); ok {
			universityID = uniID.(uint)
		}

		if !mw.adminService.HasPermission(userID.(uint), allowedRoles, universityID) {
			errs.HandleError(c, errs.NotEnoughRights)
			c.Abort()
			return
		}

		c.Next()
	}
}

func (mw *Mw) NoMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Next()
	}
}
