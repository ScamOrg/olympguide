package repository

import (
	"api/model"
	"gorm.io/gorm"
)

type IAdminRepo interface {
	GetAdminUserByID(userID uint) (*model.AdminUser, error)
}

type PgAdminRepo struct {
	db *gorm.DB
}

func NewPgAdminRepo(db *gorm.DB) *PgAdminRepo {
	return &PgAdminRepo{db: db}
}

func (p *PgAdminRepo) GetAdminUserByID(userID uint) (*model.AdminUser, error) {
	var adminUser model.AdminUser
	err := p.db.First(&adminUser, "user_id = ?", userID).Error
	if err != nil {
		return nil, err
	}
	return &adminUser, nil
}
