package users

import (
	"api/controllers/handlers"
	"api/logic"
	"github.com/gin-gonic/gin"
	"net/http"
)

func GetRegion(c *gin.Context) {
	userID, _ := c.MustGet("user_id").(uint)

	regionID := logic.GetUserRegionID(userID)
	region, err := logic.GetRegionByID(regionID)

	if err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"region_id": region.RegionID, "name": region.Name})
}
