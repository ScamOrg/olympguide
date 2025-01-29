package middleware

import (
	"api/controllers/handlers"
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
			handlers.HandleAppError(c, handlers.UserNotAdmin)
			c.Abort()
			return
		}
		universityID := c.Param("id")
		canEditUniversity := universityID == fmt.Sprint(adminUser.EditUniversityID)

		if !adminUser.IsAdmin && !adminUser.IsFounder && !canEditUniversity {
			handlers.HandleAppError(c, handlers.NotEnoughRights)
			c.Abort()
			return
		}
		c.Next()
	}
}
