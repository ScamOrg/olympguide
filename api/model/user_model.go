package model

import "time"

type User struct {
	UserID       uint `gorm:"primaryKey"`
	Email        string
	FirstName    string
	LastName     string
	SecondName   string
	Birthday     time.Time
	PasswordHash string
	RegionID     uint
	Region       Region `gorm:"foreignKey:RegionID;references:RegionID"`
}

type AdminUser struct {
	UserID           uint `gorm:"primaryKey"`
	EditUniversityID uint
	IsAdmin          bool
	IsFounder        bool
}

func (AdminUser) TableName() string { return "olympguide.admin_user" }
func (User) TableName() string      { return "olympguide.user" }
