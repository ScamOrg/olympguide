package repository

import (
	"api/model"
	"gorm.io/gorm"
)

type IUserRepo interface {
	CreateUser(user *model.User) (uint, error)
	GetUserByEmail(email string) (*model.User, error)
	GetUserByID(userID uint) (*model.User, error)
}

type PgUserRepo struct {
	db *gorm.DB
}

func NewPgUserRepo(db *gorm.DB) *PgUserRepo {
	return &PgUserRepo{db: db}
}

func (u *PgUserRepo) CreateUser(user *model.User) (uint, error) {
	if err := u.db.Create(&user).Error; err != nil {
		return 0, err
	}
	return user.UserID, nil
}

func (u *PgUserRepo) GetUserByEmail(email string) (*model.User, error) {
	var user model.User
	if err := u.db.Where("email = ?", email).First(&user).Error; err != nil {
		return nil, err
	}
	return &user, nil
}

func (u *PgUserRepo) GetUserByID(userID uint) (*model.User, error) {
	var user model.User
	if err := u.db.Preload("Region").Where("user_id = ?", userID).First(&user).Error; err != nil {
		return nil, err
	}
	return &user, nil
}
