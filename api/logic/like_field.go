package logic

import (
	"api/model"
	"api/utils"
)

func IsUserLikedField(userID any, fieldID uint) bool {
	uintUserID, ok := userID.(uint)
	if !ok {
		return false
	}
	var likedField model.LikedFields
	if err := utils.DB.Where("field_id = ? AND user_id = ?", fieldID, uintUserID).First(&likedField).Error; err == nil {
		return true
	}
	return false
}

func GetLikedFields(userID uint) ([]model.GroupField, error) {
	var likedGroups []model.GroupField
	err := utils.DB.Preload("Fields", "field_id IN (SELECT field_id FROM olympguide.liked_fields)").
		Joins("JOIN olympguide.field_of_study AS fos ON fos.group_id = group_of_fields.group_id").
		Joins("JOIN olympguide.liked_fields AS lf ON lf.field_id = fos.field_id").
		Where("lf.user_id = ?", userID).
		Distinct().
		Find(&likedGroups).Error
	if err != nil {
		return nil, err
	}
	return likedGroups, nil
}

func LikeField(userID uint, fieldID uint) error {
	likedFields := model.LikedFields{
		FieldID: fieldID,
		UserID:  userID,
	}
	err := utils.DB.Create(&likedFields).Error
	return err
}

func UnlikeField(userID uint, fieldID uint) error {
	likedFields := model.LikedFields{
		FieldID: fieldID,
		UserID:  userID,
	}
	err := utils.DB.Delete(&likedFields).Error
	return err
}
