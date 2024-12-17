package controllers

import (
	"api/db"
	"api/models"
	"errors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"net/http"
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
