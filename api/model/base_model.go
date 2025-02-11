package model

type Olympiad struct {
	OlympiadID  uint `gorm:"primaryKey"`
	Name        string
	Description string
	Level       int16
	Profile     string
	Link        string
	Popularity  int
	Like        bool `gorm:"column:like;->"`
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
	Like         bool   `gorm:"column:like;->"`
}

type Program struct {
	ProgramID        uint `gorm:"primaryKey"`
	Name             string
	BudgetPlaces     uint
	PaidPlaces       uint
	Cost             uint
	Link             string
	UniversityID     uint
	FacultyID        uint
	FieldID          uint
	University       University `gorm:"foreignKey:UniversityID;references:UniversityID"`
	Faculty          Faculty    `gorm:"foreignKey:FacultyID;references:FacultyID"`
	Field            Field      `gorm:"foreignKey:FieldID;references:FieldID"`
	OptionalSubjects []Subject  `gorm:"many2many:program_optional_subjects;"`
	RequiredSubjects []Subject  `gorm:"many2many:program_required_subjects;"`
	Like             bool       `gorm:"column:like;->"`
}

func (Field) TableName() string      { return "olympguide.field_of_study" }
func (Olympiad) TableName() string   { return "olympguide.olympiad" }
func (University) TableName() string { return "olympguide.university" }
func (Program) TableName() string    { return "olympguide.educational_program" }
