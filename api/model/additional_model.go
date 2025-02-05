package model

type GroupField struct {
	GroupID uint
	Name    string
	Code    string
	Fields  []Field `gorm:"foreignKey:GroupID;references:GroupID"`
}

type Region struct {
	RegionID uint `gorm:"primaryKey"`
	Name     string
}

func (Region) TableName() string     { return "olympguide.region" }
func (GroupField) TableName() string { return "olympguide.group_of_fields" }
