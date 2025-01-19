package models

import "time"

type Olympiad struct {
	OlympiadID  uint   `json:"olympiad_id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	Level       int16  `json:"level"`
	Profile     string `json:"profile"`
	Link        string `json:"link"`
}

type Field struct {
	FieldID uint   `json:"-"`
	Name    string `json:"name"`
	Code    string `json:"code"`
	Degree  string `json:"degree"`
	GroupID uint   `json:"-"`
}

type GroupField struct {
	GroupID uint    `json:"-"`
	Name    string  `json:"name"`
	Code    string  `json:"code"`
	Fields  []Field `json:"fields" gorm:"foreignKey:GroupID;references:GroupID"`
}

type User struct {
	UserID       uint `gorm:"primaryKey"`
	Email        string
	FirstName    string
	LastName     string
	SecondName   string
	Birthday     time.Time
	PasswordHash string
	RegionID     uint
}

type AdminUser struct {
	UserID           uint `gorm:"primaryKey"`
	EditUniversityID uint
	IsAdmin          bool
	IsFounder        bool
}

type University struct {
	UniversityID uint `gorm:"primaryKey"`
	Name         string
	Logo         string
	Email        string
	Site         string
	Description  string
	RegionID     uint
	Popularity   int
	Region       Region `gorm:"foreignKey:RegionID;references:RegionID"`
}

type Region struct {
	RegionID uint `gorm:"primaryKey"`
	Name     string
}

type LikedUniversities struct {
	UniversityID uint `gorm:"primaryKey"`
	UserID       uint `gorm:"primaryKey"`
}

func (LikedUniversities) TableName() string { return "olympguide.liked_universities" }
func (AdminUser) TableName() string         { return "olympguide.admin_user" }
func (University) TableName() string        { return "olympguide.university" }
func (Region) TableName() string            { return "olympguide.region" }
func (User) TableName() string              { return "olympguide.user" }
func (Olympiad) TableName() string          { return "olympguide.olympiad" }
func (GroupField) TableName() string        { return "olympguide.group_of_fields" }
func (Field) TableName() string             { return "olympguide.field_of_study" }
