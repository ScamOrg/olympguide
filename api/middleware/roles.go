package middleware

import (
	"api/service"
	"api/utils/errs"
	"api/utils/role"
	"github.com/gin-gonic/gin"
	"os"
)

type Mw struct {
	adminService service.IAdminService
}

func NewMw(adminService service.IAdminService) *Mw {
	return &Mw{adminService: adminService}
}

func (mw *Mw) RolesMiddleware(allowedRoles ...string) gin.HandlerFunc {
	return func(c *gin.Context) {
		bearerToken := c.GetHeader("Authorization")
		for _, allowedRole := range allowedRoles {
			if allowedRole == role.DataLoaderService && bearerToken == "Bearer "+os.Getenv("BEARER_DATA_LOADER_TOKEN") {
				c.Next()
				return
			}
		}

		userID, exists := c.Get("user_id")
		if !exists {
			errs.HandleError(c, errs.Unauthorized)
			c.Abort()
			return
		}

		var universityID uint
		if uniID, ok := c.Get("university_id"); ok {
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
