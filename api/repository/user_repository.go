package repository

import (
	"api/models"
	"gorm.io/gorm"
)

type IUserRepo interface {
	GetAll() ([]models.User, error)
	Create(user models.User) error
}

type PgUserRepo struct {
	db *gorm.DB
}

func NewPgUserRepo(db *gorm.DB) *PgUserRepo {
	return &PgUserRepo{db: db}
}
