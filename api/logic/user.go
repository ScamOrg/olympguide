package logic

import (
	"api/models"
	"api/utils"
	"log"
)

func CreateUser(user *models.User) (uint, error) {
	if err := utils.DB.Create(&user).Error; err != nil {
		log.Println(err)
		return 0, err
	}
	return user.UserID, nil
}

func GetUserByEmail(email string) (*models.User, error) {
	var user models.User
	if err := utils.DB.Where("email = ?", email).First(&user).Error; err != nil {
		log.Println(err)
		return nil, err
	}
	return &user, nil
}
