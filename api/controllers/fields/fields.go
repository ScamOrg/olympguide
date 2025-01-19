package fields

import (
	"api/constants"
	"api/db"
	"api/models"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"net/http"
	"strconv"
)

func GetFields(c *gin.Context) {
	var groups []models.GroupField

	err := db.DB.Preload("Fields", func(db *gorm.DB) *gorm.DB {
		if degrees := c.QueryArray("degree"); len(degrees) > 0 {
			db = db.Where("degree IN (?)", degrees)
		}
		if name := c.Query("search"); name != "" {
			db = db.Where("name ILIKE ? OR code ILIKE ?", "%"+name+"%", "%"+name+"%")
		}
		return db
	}).Find(&groups).Error

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		return
	}

	var filteredGroups []models.GroupField
	for _, group := range groups {
		if len(group.Fields) > 0 {
			filteredGroups = append(filteredGroups, group)
		}
	}

	c.JSON(http.StatusOK, filteredGroups)
}

func GetFieldByID(c *gin.Context) {
	idParam := c.Param("id")
	fieldID, err := strconv.Atoi(idParam)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": constants.InvalidRequest})
		return
	}
	var field models.Field
	result := db.DB.First(&field, fieldID)
	if result.Error != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": constants.DataNotFound})
		return
	}
	c.JSON(http.StatusOK, field)
}
