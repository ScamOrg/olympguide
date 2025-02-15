package dto

type FieldShortInfo struct {
	FieldID uint   `json:"field_id"`
	Name    string `json:"name"`
	Code    string `json:"code"`
	Degree  string `json:"degree"`
}
type GroupResponse struct {
	Name   string           `json:"name"`
	Code   string           `json:"code"`
	Fields []FieldShortInfo `json:"field"`
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

type GroupQueryParams struct {
	Degrees []string `form:"degree"`
	Search  string   `form:"search"`
}

type GroupProgramTree struct {
	GroupID  uint                   `json:"group_id"`
	Name     string                 `json:"name"`
	Code     string                 `json:"code"`
	Programs []ProgramShortResponse `json:"programs"`
}
