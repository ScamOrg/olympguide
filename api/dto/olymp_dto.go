package dto

// OlympQueryParams представляет параметры запроса для фильтрации и сортировки олимпиад.
type OlympQueryParams struct {
	Levels   []uint   `form:"level" example:"1,2"`      // Уровень олимпиады (можно передавать несколько)
	Profiles []string `form:"profile" example:"физика"` // Профиль олимпиады
	Search   string   `form:"search" example:"Росатом"` // Поиск по названию
	Sort     string   `form:"sort" example:"level"`     // Поле сортировки (level, profile, name)
	Order    string   `form:"order" example:"asc"`      // Порядок сортировки (asc, desc)
	UserID   any      `swaggerignore:"true"`            // ID пользователя (не передаётся в запросе)
}

// OlympiadShortResponse представляет сокращённую информацию об олимпиаде.
type OlympiadShortResponse struct {
	OlympiadID uint   `json:"olympiad_id" example:"123"`                      // ID олимпиады
	Name       string `json:"name" example:"Олимпиада Росатом по математике"` // Название олимпиады
	Level      int16  `json:"level" example:"1"`                              // Уровень олимпиады
	Profile    string `json:"profile" example:"физика"`                       // Профиль олимпиады
	Like       bool   `json:"like" example:"true"`                            // Лайкнута ли олимпиада пользователем
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
