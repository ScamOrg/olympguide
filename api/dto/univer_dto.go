package dto

type UniversityRequest struct {
	Name        string `json:"name" binding:"required"`
	ShortName   string `json:"short_name" binding:"required"`
	Logo        string `json:"logo"`
	Email       string `json:"email"`
	Site        string `json:"site"`
	Description string `json:"description"`
	RegionID    uint   `json:"region_id" binding:"required"`
}

// UniversityShortResponse представляет краткую информацию об университете.
//
// @Description Ответ API с краткими сведениями об университете.
type UniversityShortResponse struct {
	UniversityID uint   `json:"university_id" example:"123"`                           // ID университета
	Name         string `json:"name" example:"Московский государственный университет"` // Полное название
	ShortName    string `json:"short_name" example:"МГУ"`                              // Краткое название
	Logo         string `json:"logo" example:"https://example.com/logo.png"`           // URL логотипа
	Region       string `json:"region" example:"Москва"`                               // Название региона
	Like         bool   `json:"like" example:"true"`                                   // Лайкнут ли университет пользователем
}

// UniversityQueryParams представляет параметры запроса для поиска университетов.
type UniversityQueryParams struct {
	Regions      []string `form:"region"`         // Список регионов для фильтрации
	FromMyRegion bool     `form:"from_my_region"` // Искать университеты только из региона пользователя
	Search       string   `form:"search"`         // Поиск по названию или сокращенному названию
	UserID       any      `swaggerignore:"true"`  // ID пользователя (не передаётся в запросе)
}

type UniversityResponse struct {
	Email       string `json:"email"`
	Site        string `json:"site"`
	Description string `json:"description"`
	UniversityShortResponse
}

type UniversityForProgramInfo struct {
	UniversityID uint   `json:"university_id"`
	Name         string `json:"name"`
	ShortName    string `json:"short_name"`
	Region       string `json:"region"`
	Logo         string `json:"logo"`
}
