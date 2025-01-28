package middleware

import (
	"api/constants"
	"api/models"
	"api/utils"
	"fmt"
	"github.com/gin-gonic/gin"
	"net/http"
)

func UniversityMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		userID, _ := c.Get("user_id")
		var adminUser models.AdminUser
		if err := utils.DB.Where("user_id = ?", userID).First(&adminUser).Error; err != nil {
			c.AbortWithStatusJSON(http.StatusForbidden, gin.H{"error": constants.UserNotAdmin})
			return
		}
		universityID := c.Param("id")
		canEditUniversity := universityID == fmt.Sprint(adminUser.EditUniversityID)

		if !adminUser.IsAdmin && !adminUser.IsFounder && !canEditUniversity {
			c.AbortWithStatusJSON(http.StatusForbidden, gin.H{"error": constants.NotEnoughRights})
			return
		}
		c.Next()
	}
}
