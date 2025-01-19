package middleware

import (
	"api/constants"
	"api/db"
	"api/models"
	"fmt"
	"github.com/gin-gonic/gin"
	"net/http"
)

func UniversityMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		userID, _ := c.Get("user_id")
		var adminUser models.AdminUser
		if err := db.DB.Where("user_id = ?", userID).First(&adminUser).Error; err != nil {
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
