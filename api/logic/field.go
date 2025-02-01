package logic

import (
	"api/models"
	"api/utils"
	"gorm.io/gorm"
)

func GetFieldByID(fieldID string) (*models.Field, error) {
	var field models.Field
	if err := utils.DB.Preload("Group").First(&field, fieldID).Error; err != nil {
		return nil, err
	}
	return &field, nil
}

func GetFields(degrees []string, search string) ([]models.GroupField, error) {
	var groups []models.GroupField
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
