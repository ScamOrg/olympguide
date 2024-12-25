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

func (Olympiad) TableName() string   { return "olympguide.olympiad" }
func (GroupField) TableName() string { return "olympguide.group_of_fields" }
func (Field) TableName() string      { return "olympguide.field_of_study" }
