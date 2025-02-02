package repository

import (
	"api/models"
	"gorm.io/gorm"
)

type UserRepository interface {
	GetAll() ([]models.User, error)
	Create(user models.User) error
}

type UserRepositoryImpl struct {
	db *gorm.DB
}

func NewUserRepository(db *gorm.DB) *UserRepositoryImpl {
	return &UserRepositoryImpl{db: db}
}
