package models

type Olympiad struct {
	OlympiadID  uint   `json:"olympiad_id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	Level       int16  `json:"level"`
	Profile     string `json:"profile"`
	Link        string `json:"link"`
}

type Field struct {
	FieldID uint `gorm:"primaryKey"`
	Name    string
	Code    string
	Degree  string
	GroupID uint
	Group   GroupField `gorm:"foreignKey:GroupID;references:GroupID"`
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

type Faculty struct {
	FacultyID    uint `gorm:"primaryKey"`
	Name         string
	Description  string
	UniversityID uint
	University   University `gorm:"foreignKey:UniversityID;references:UniversityID"`
}

type Program struct {
	ProgramID    uint `gorm:"primaryKey"`
	Name         string
	BudgetPlaces uint
	PaidPlaces   uint
	Cost         uint
	Link         string
	UniversityID uint
	FacultyID    uint
	FieldID      uint
	University   University `gorm:"foreignKey:UniversityID;references:UniversityID"`
	Faculty      Faculty    `gorm:"foreignKey:FacultyID;references:FacultyID"`
	Field        Field      `gorm:"foreignKey:FieldID;references:FieldID"`
}

func (Field) TableName() string      { return "olympguide.field_of_study" }
func (Olympiad) TableName() string   { return "olympguide.olympiad" }
func (University) TableName() string { return "olympguide.university" }
func (Faculty) TableName() string    { return "olympguide.faculty" }
