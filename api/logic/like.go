package logic

import (
	"api/models"
	"api/utils"
)

func GetLikedUniversities(userID uint) ([]models.University, error) {
	var universities []models.University

	if err := utils.DB.
		Joins("JOIN olympguide.liked_universities AS lu ON university.university_id = lu.university_id").
		Where("lu.user_id = ?", userID).
		Preload("Region").
		Find(&universities).Error; err != nil {
		return nil, err
	}

	return universities, nil
}

func IsUserLikedUniversity(userID any, universityID uint) bool {
	uintUserID, ok := userID.(uint)
	if !ok {
		return false
	}
	var likedUniversity models.LikedUniversities
	if err := utils.DB.Where("university_id = ? AND user_id = ?", universityID, uintUserID).First(&likedUniversity).Error; err == nil {
		return true
	}
	return false
}

func LikeUniversity(userID uint, universityID uint) error {
	likedUniversity := models.LikedUniversities{
		UniversityID: universityID,
		UserID:       userID,
	}
	err := utils.DB.Create(&likedUniversity).Error
	return err
}

func UnlikeUniversity(userID uint, universityID uint) error {
	likedUniversity := models.LikedUniversities{
		UniversityID: universityID,
		UserID:       userID,
	}
	err := utils.DB.Delete(&likedUniversity).Error
	return err
}
