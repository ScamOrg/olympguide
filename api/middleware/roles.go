package middleware

import (
	"api/errs"
	"api/models"
	"api/utils"
	"fmt"
	"github.com/gin-gonic/gin"
)

func UniversityMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		userID, _ := c.Get("user_id")
		var adminUser models.AdminUser
		if err := utils.DB.Where("user_id = ?", userID).First(&adminUser).Error; err != nil {
			err.HandleAppError(c, err.UserNotAdmin)
			c.Abort()
			return
		}
		universityID := c.Param("id")
		canEditUniversity := universityID == fmt.Sprint(adminUser.EditUniversityID)

		if !adminUser.IsAdmin && !adminUser.IsFounder && !canEditUniversity {
			errs.HandleAppError(c, errs.NotEnoughRights)
			c.Abort()
			return
		}
		c.Next()
	}
}
