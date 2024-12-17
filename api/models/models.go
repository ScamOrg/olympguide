package models

type Olympiad struct {
	OlympiadID  uint   `json:"olympiad_id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	Level       int16  `json:"level"`
	Profile     string `json:"profile"`
	Link        string `json:"link"`
}

func (Olympiad) TableName() string {
	return "olympguide.olympiad"
}
