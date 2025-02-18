package dto

type ProgramShortResponse struct {
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
	ProgramShortResponse
	University UniversityForProgramInfo `json:"university"`
	Link       string                   `json:"link"`
}

type ProgramRequest struct {
	Name             string `json:"name" binding:"required"`
	BudgetPlaces     uint   `json:"budget_places"`
	PaidPlaces       uint   `json:"paid_places"`
	Cost             uint   `json:"cost"`
	Link             string `json:"link"`
	UniversityID     uint   `json:"university_id" binding:"required"`
	FacultyID        uint   `json:"faculty_id" binding:"required"`
	FieldID          uint   `json:"field_id" binding:"required"`
	OptionalSubjects []uint `json:"optional_subjects"`
	RequiredSubjects []uint `json:"required_subjects"`
}

type ProgramBenefitInfo struct {
	ProgramID       uint   `json:"program_id"`
	Name            string `json:"name"`
	Field           string `json:"field"`
	UniverShortName string `json:"university"`
}
