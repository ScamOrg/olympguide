package repository

import (
	"api/model"
	"gorm.io/gorm"
)

type IUniverRepo interface {
	GetUniver(universityID string, userID any) (*model.University, error)
}

type PgUniverRepo struct {
	db *gorm.DB
}

func NewPgUniverRepo(db *gorm.DB) *PgUniverRepo {
	return &PgUniverRepo{db: db}
}

func (u PgUniverRepo) GetUniver(universityID string, userID any) (*model.University, error) {
	var university model.University
	err := u.db.Debug().Preload("Region").
		Joins("LEFT JOIN olympguide.liked_universities lu ON lu.university_id = olympguide.university.university_id AND lu.user_id = ?", userID).
		Select("olympguide.university.*, CASE WHEN lu.user_id IS NOT NULL THEN TRUE ELSE FALSE END as like").
		Where("olympguide.university.university_id = ?", universityID).
		First(&university).Error
	if err != nil {
		return nil, err
	}
	return &university, nil
}
