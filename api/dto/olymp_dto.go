package dto

type OlympQueryParams struct {
	Levels   []string `form:"level"`
	Profiles []string `form:"profile"`
	Search   string   `form:"search"`
	Sort     string   `form:"sort"`
	Order    string   `form:"order"`
	UserID   any
}

type OlympiadShortResponse struct {
	OlympiadID uint   `json:"olympiad_id"`
	Name       string `json:"name"`
	Level      int16  `json:"level"`
	Profile    string `json:"profile"`
	Like       bool   `json:"like"`
}

type OlympiadResponse struct {
	OlympiadShortResponse
	Description string `json:"description"`
	Link        string `json:"link"`
}

type OlympiadBenefitInfo struct {
	OlympiadID uint   `json:"olympiad_id"`
	Name       string `json:"name"`
	Level      int16  `json:"level"`
	Profile    string `json:"profile"`
}
