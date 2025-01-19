package olympiads

import (
	"api/constants"
	"api/db"
	"api/models"
	"errors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"net/http"
)

func GetOlympiads(c *gin.Context) {
	var olympiads []models.Olympiad
	query := db.DB.Model(&models.Olympiad{}).Debug()

	levels := c.QueryArray("level")
	if len(levels) > 0 {
		query = query.Where("level IN (?)", levels)
	}

	profiles := c.QueryArray("profile")
	if len(profiles) > 0 {
		query = query.Where("profile IN (?)", profiles)
	}

	if nameLike := c.Query("name"); nameLike != "" {
		query = query.Where("name ILIKE ?", "%"+nameLike+"%")
	}

	sortBy := c.Query("sort")
	order := c.Query("order")

	allowedSortFields := map[string]bool{
		"level":   true,
		"profile": true,
		"name":    true,
	}

	if allowedSortFields[sortBy] {
		if order != "asc" && order != "desc" {
			order = "asc"
		}
		query = query.Order(sortBy + " " + order)
	}

	err := query.Find(&olympiads).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": constants.DataNotFound})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		return
	}

	c.JSON(http.StatusOK, olympiads)
}
