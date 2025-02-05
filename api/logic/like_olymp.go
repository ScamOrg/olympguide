package logic

import (
	"api/model"
	"api/utils"
	"api/utils/constants"
)

func ServiceLikeOlympiad(olympiadID string, userID uint) (bool, error) {
	olympiad, err := GetOlympiadByID(olympiadID)
	if err != nil {
		return false, err
	}

	isLiked := IsUserLikedOlympiad(userID, olympiad.OlympiadID)
	if isLiked {
		return false, nil
	}

	err = logic.LikeOlympiad(userID, olympiad.OlympiadID)
	if err != nil {
		return false, err
	}
	logic.ChangeOlympiadPopularity(olympiad, constants.LikePopularityIncrease)
	return true, nil
}

func IsUserLikedOlympiad(userID any, olympiadID uint) bool {
	uintUserID, ok := userID.(uint)
	if !ok {
		return false
	}
	var likedOlymp model.LikedOlympiads
	if err := utils.DB.Where("olympiad_id = ? AND user_id = ?", olympiadID, uintUserID).First(&likedOlymp).Error; err == nil {
		return true
	}
	return false
}

func GetLikedOlympiads(userID uint) ([]model.Olympiad, error) {
	var olympiads []model.Olympiad

	if err := utils.DB.
		Joins("JOIN olympguide.liked_olympiads AS lo ON olympiad.olympiad_id = lo.olympiad_id").
		Where("lo.user_id = ?", userID).
		Find(&olympiads).Error; err != nil {
		return nil, err
	}

	return olympiads, nil
}

func LikeOlympiad(userID uint, olympiadID uint) error {
	likedOlympiads := model.LikedOlympiads{
		OlympiadID: olympiadID,
		UserID:     userID,
	}
	err := utils.DB.Create(&likedOlympiads).Error
	return err
}

func UnlikeOlympiad(userID uint, olympiadID uint) error {
	likedOlympiads := model.LikedOlympiads{
		OlympiadID: olympiadID,
		UserID:     userID,
	}
	err := utils.DB.Delete(&likedOlympiads).Error
	return err
}
