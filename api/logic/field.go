package logic

import (
	"api/models"
	"api/utils"
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
	query := utils.DB.Preload("Fields")

	if len(degrees) > 0 {
		query = query.Where("degree IN (?)", degrees)
	}
	if search != "" {
		query = query.Where("name ILIKE ? OR code ILIKE ?", "%"+search+"%", "%"+search+"%")
	}

	if err := query.Find(&groups).Error; err != nil {
		return nil, err
	}
	return groups, nil
}
