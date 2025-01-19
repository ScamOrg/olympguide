package likes

import (
	"api/constants"
	universities2 "api/controllers/universities"
	"api/db"
	"api/models"
	"errors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"net/http"
)

func GetLikedUniversities(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var universities []models.University
	if err := db.DB.
		Joins("JOIN olympguide.liked_universities AS lu ON university.university_id = lu.university_id").
		Where("lu.user_id = ?", userID).
		Preload("Region").
		Find(&universities).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		return
	}

	var response []universities2.UniversityShortResponse
	for _, university := range universities {
		response = append(response, universities2.UniversityShortResponse{
			UniversityID: university.UniversityID,
			Name:         university.Name,
			Logo:         university.Logo,
			Region:       university.Region.Name,
			Like:         true,
		})
	}
	c.JSON(http.StatusOK, response)
}

func LikeUniversity(c *gin.Context) {
	universityID := c.Param("id")
	userID, _ := c.Get("user_id")

	var university models.University
	if err := db.DB.First(&university, universityID).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": constants.DataNotFound})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		}
		return
	}

	var likedUniversity models.LikedUniversities
	if err := db.DB.Where("university_id = ? AND user_id = ?", universityID, userID).First(&likedUniversity).Error; err == nil {
		return
	}

	likedUniversity = models.LikedUniversities{
		UniversityID: university.UniversityID,
		UserID:       userID.(uint),
	}

	if err := db.DB.Create(&likedUniversity).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Liked"})
}

func UnlikeUniversity(c *gin.Context) {
	universityID := c.Param("id")
	userID, _ := c.Get("user_id")

	var likedUniversity models.LikedUniversities
	if err := db.DB.Where("university_id = ? AND user_id = ?", universityID, userID).First(&likedUniversity).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.Status(http.StatusOK)
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
		}
		return
	}

	if err := db.DB.Delete(&likedUniversity).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "University unliked"})
}
