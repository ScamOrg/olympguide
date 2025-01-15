package users

import (
	"api/constants"
	"api/db"
	"api/models"
	"errors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"net/http"
)

func GetRegion(c *gin.Context) {
	userID, _ := c.Get("user_id")
	userIDUint, _ := userID.(uint)

	var user models.User
	if err := db.DB.First(&user, userIDUint).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": constants.UserNotFound})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		}
		return
	}

	var region models.Region
	if err := db.DB.First(&region, user.RegionID).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": constants.RegionNotFound})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		}
		return
	}
	c.JSON(http.StatusOK, gin.H{"region_id": region.RegionID, "name": region.Name})
}
