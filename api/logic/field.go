package logic

import (
	"api/model"
	"api/utils"
	"gorm.io/gorm"
)

func GetFieldByID(fieldID string) (*model.Field, error) {
	var field model.Field
	if err := utils.DB.Preload("Group").First(&field, fieldID).Error; err != nil {
		return nil, err
	}
	return &field, nil
}

func GetFields(degrees []string, search string) ([]model.GroupField, error) {
	var groups []model.GroupField
	query := utils.DB.Preload("Fields", func(db *gorm.DB) *gorm.DB {
		if len(degrees) > 0 {
			db = db.Where("degree IN (?)", degrees)
		}
		if search != "" {
			db = db.Where("name ILIKE ? OR code ILIKE ?", "%"+search+"%", "%"+search+"%")
		}
		return db
	}).Find(&groups)
	if err := query.Error; err != nil {
		return nil, err
	}
	return groups, nil
}
