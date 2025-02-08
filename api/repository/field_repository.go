package repository

import (
	"api/model"
	"gorm.io/gorm"
)

type IFieldRepo interface {
	GetField(fieldID string) (*model.Field, error)
	GetGroups(search string, degrees []string) ([]model.GroupField, error)
}
type PgFieldRepo struct {
	db *gorm.DB
}

func NewPgFieldRepo(db *gorm.DB) *PgFieldRepo {
	return &PgFieldRepo{db: db}
}

func (f *PgFieldRepo) GetField(fieldID string) (*model.Field, error) {
	var field model.Field
	if err := f.db.Preload("Group").First(&field, fieldID).Error; err != nil {
		return nil, err
	}
	return &field, nil
}

func (f *PgFieldRepo) GetGroups(search string, degrees []string) ([]model.GroupField, error) {
	var groups []model.GroupField
	query := f.db.Preload("Fields", func(db *gorm.DB) *gorm.DB {
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
