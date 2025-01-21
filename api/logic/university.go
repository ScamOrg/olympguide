package logic

import (
	"api/db"
	"api/models"
	"github.com/gin-gonic/gin"
	"log"
)

func GetUniversityByID(universityID string) (*models.University, error) {
	var university models.University
	if err := db.DB.Preload("Region").First(&university, universityID).Error; err != nil {
		return nil, err
	}
	return &university, nil
}

func GetUniversities(c *gin.Context) ([]models.University, error) {
	var universities []models.University

	regionIDs := c.QueryArray("region_id")
	fromMyRegion := c.Query("from_my_region") == "true"

	query := db.DB.Preload("Region")

	if fromMyRegion {
		userRegionID := GetUserRegionID(c)
		query = query.Where("region_id = ?", userRegionID)
	} else if len(regionIDs) > 0 {
		query = query.Where("region_id IN (?)", regionIDs)
	}

	if err := query.Find(&universities).Error; err != nil {
		return nil, err
	}
	log.Println(universities)
	return universities, nil
}

func DeleteUniversity(university *models.University) error {
	if err := db.DB.Delete(university).Error; err != nil {
		return err
	}
	return nil
}

func CreateUniversity(university *models.University) (uint, error) {
	if err := db.DB.Create(&university).Error; err != nil {
		return 0, err
	}
	return university.UniversityID, nil
}

func UpdateUniversity(university *models.University) error {
	if err := db.DB.Save(university).Error; err != nil {
		return err
	}
	return nil
}

func IncrementUniversityPopularity(university *models.University) {
	university.Popularity += 1
	db.DB.Save(university)
}

func IsUserLikedUniversity(c *gin.Context, universityID string) bool {
	userID, exists := c.Get("user_id")
	if !exists {
		return false
	}
	var likedUniversity models.LikedUniversities
	if err := db.DB.Where("university_id = ? AND user_id = ?", universityID, userID).First(&likedUniversity).Error; err == nil {
		return true
	}
	return false
}
