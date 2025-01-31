package logic

import (
	"api/models"
	"api/utils"
)

func IsUserLikedField(userID any, fieldID uint) bool {
	uintUserID, ok := userID.(uint)
	if !ok {
		return false
	}
	var likedField models.LikedFields
	if err := utils.DB.Where("field_id = ? AND user_id = ?", fieldID, uintUserID).First(&likedField).Error; err == nil {
		return true
	}
	return false
}
