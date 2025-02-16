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

type Faculty struct {
	FacultyID    uint `gorm:"primaryKey"`
	Name         string
	Description  string
	UniversityID uint
	University   University `gorm:"foreignKey:UniversityID;references:UniversityID"`
	Programs     []Program  `gorm:"foreignKey:FacultyID;references:FacultyID"`
}

type Subject struct {
	SubjectID uint `gorm:"primaryKey"`
	Name      string
}

type Diploma struct {
	DiplomaID  uint `gorm:"primaryKey"`
	UserID     uint
	OlympiadID uint
	Class      uint
	Level      uint
	Olympiad   Olympiad `gorm:"foreignKey:OlympiadID;references:OlympiadID"`
}

func (Region) TableName() string     { return "olympguide.region" }
func (GroupField) TableName() string { return "olympguide.group_of_fields" }
func (Faculty) TableName() string    { return "olympguide.faculty" }
func (Subject) TableName() string    { return "olympguide.subject" }
func (Diploma) TableName() string    { return "olympguide.diploma" }
