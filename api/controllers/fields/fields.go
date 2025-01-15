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
	degree := c.Query("degree")
	err := db.DB.Preload("Fields", func(db *gorm.DB) *gorm.DB {
		if degree != "" {
			return db.Where("degree = ?", degree)
		}
		return db
	}).Find(&groups).Error

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		return
	}
	c.JSON(http.StatusOK, groups)
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
