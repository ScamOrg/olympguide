package logic

import (
	"api/db"
	"api/models"
	"github.com/gin-gonic/gin"
)

func IsRegionExists(regionID uint) bool {
	var regionExists bool
	db.DB.Raw("SELECT EXISTS(SELECT 1 FROM olympguide.region WHERE region_id = ?)", regionID).Scan(&regionExists)
	return regionExists
}

func GetUserRegionID(c *gin.Context) uint {
	userID, exists := c.Get("user_id")
	if !exists {
		return 0
	}
	var user models.User
	if err := db.DB.Select("region_id").First(&user, userID).Error; err != nil {
		return 0
	}
	return user.RegionID
}
