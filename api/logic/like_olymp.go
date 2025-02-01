package logic

import (
	"api/models"
	"api/utils"
)

func IsUserLikedOlympiad(userID any, olympiadID uint) bool {
	uintUserID, ok := userID.(uint)
	if !ok {
		return false
	}
	var likedOlymp models.LikedOlympiads
	if err := utils.DB.Where("olympiad_id = ? AND user_id = ?", olympiadID, uintUserID).First(&likedOlymp).Error; err == nil {
		return true
	}
	return false
}

func GetLikedOlympiads(userID uint) ([]models.Olympiad, error) {
	var olympiads []models.Olympiad

	if err := utils.DB.
		Joins("JOIN olympguide.liked_olympiads AS lo ON olympiad.olympiad_id = lo.olympiad_id").
		Where("lo.user_id = ?", userID).
		Find(&olympiads).Error; err != nil {
		return nil, err
	}

	return olympiads, nil
}

func LikeOlympiad(userID uint, olympiadID uint) error {
	likedOlympiads := models.LikedOlympiads{
		OlympiadID: olympiadID,
		UserID:     userID,
	}
	err := utils.DB.Create(&likedOlympiads).Error
	return err
}

func UnlikeOlympiad(userID uint, olympiadID uint) error {
	likedOlympiads := models.LikedOlympiads{
		OlympiadID: olympiadID,
		UserID:     userID,
	}
	err := utils.DB.Delete(&likedOlympiads).Error
	return err
}
