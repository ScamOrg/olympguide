package dto

// FieldShortInfo содержит краткую информацию о направлении подготовки.
//
// @Description Краткая информация о направлении подготовки.
type FieldShortInfo struct {
	FieldID uint   `json:"field_id" example:"1"`         // ID направления подготовки
	Name    string `json:"name" example:"Математика"`    // Название направления
	Code    string `json:"code" example:"01.03.01"`      // Код направления
	Degree  string `json:"degree" example:"Бакалавриат"` // Уровень образования
}

// GroupResponse представляет ответ с группами направлений.
//
// @Description Группа направлений подготовки с их параметрами.
type GroupResponse struct {
	Name   string           `json:"name" example:"Математические науки"` // Название группы
	Code   string           `json:"code" example:"01.00.00"`             // Код группы
	Fields []FieldShortInfo `json:"fields"`                              // Список направлений в группе
}

type GroupShortInfo struct {
	Name string `json:"name"`
	Code string `json:"code"`
}

type FieldResponse struct {
	FieldID uint           `json:"field_id"`
	Name    string         `json:"name"`
	Code    string         `json:"code"`
	Degree  string         `json:"degree"`
	Group   GroupShortInfo `json:"group"`
}

// GroupQueryParams содержит параметры запроса для фильтрации групп.
//
// @Description Параметры запроса для поиска и фильтрации групп направлений подготовки.
type GroupQueryParams struct {
	Degrees []string `form:"degree" example:"Бакалавриат"` // Уровень образования
	Search  string   `form:"search" example:"Математика"`  // Поиск по названию или коду
}

type GroupProgramTree struct {
	GroupID  uint                   `json:"group_id"`
	Name     string                 `json:"name"`
	Code     string                 `json:"code"`
	Programs []ProgramShortResponse `json:"programs"`
}
