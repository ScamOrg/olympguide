package controllers

import (
	"api/db"
	"api/models"
	"errors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"net/http"
	"strconv"
)

func GetOlympiads(c *gin.Context) {
	var olympiads []models.Olympiad
	err := db.DB.Find(&olympiads).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": "Olympiads not found"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, olympiads)
}

func GetFields(c *gin.Context) {
	var groups []models.GroupField
	if err := db.DB.Preload("Fields").Find(&groups).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, groups)
}

func GetFieldByID(c *gin.Context) {
	idParam := c.Param("id")
	fieldID, err := strconv.Atoi(idParam)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid FieldID"})
		return
	}
	var field models.Field
	result := db.DB.First(&field, fieldID)
	if result.Error != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Field not found"})
		return
	}
	c.JSON(http.StatusOK, field)
}
