package logic

import (
	"api/model"
	"api/utils"
	"log"
)

func CreateUser(user *model.User) (uint, error) {
	if err := utils.DB.Create(&user).Error; err != nil {
		log.Println(err)
		return 0, err
	}
	return user.UserID, nil
}

func GetUserByEmail(email string) (*model.User, error) {
	var user model.User
	if err := utils.DB.Where("email = ?", email).First(&user).Error; err != nil {
		log.Println(err)
		return nil, err
	}
	return &user, nil
}
