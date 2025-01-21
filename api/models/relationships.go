package models

type LikedUniversities struct {
	UniversityID uint `gorm:"primaryKey"`
	UserID       uint `gorm:"primaryKey"`
}

func (LikedUniversities) TableName() string { return "olympguide.liked_universities" }
