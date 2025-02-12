package dto

type ProgramInUniverResponse struct {
	ProgramID        uint     `json:"program_id"`
	Name             string   `json:"name"`
	Field            string   `json:"field"`
	BudgetPlaces     uint     `json:"budget_places"`
	PaidPlaces       uint     `json:"paid_places"`
	Cost             uint     `json:"cost"`
	RequiredSubjects []string `json:"required_subjects"`
	OptionalSubjects []string `json:"optional_subjects"`
	Like             bool     `json:"like"`
}

type ProgramResponse struct {
	ProgramID        uint                     `json:"program_id"`
	Name             string                   `json:"name"`
	Field            string                   `json:"field"`
	BudgetPlaces     uint                     `json:"budget_places"`
	PaidPlaces       uint                     `json:"paid_places"`
	Cost             uint                     `json:"cost"`
	RequiredSubjects []string                 `json:"required_subjects"`
	OptionalSubjects []string                 `json:"optional_subjects"`
	Like             bool                     `json:"like"`
	University       UniversityForProgramInfo `json:"university"`
}
