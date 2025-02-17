package dto

type BenefitRequest struct {
	OlympiadID        uint               `json:"olympiad_id" binding:"required"`
	ProgramID         uint               `json:"program_id" binding:"required"`
	MinClass          uint               `json:"min_class" binding:"required,min=9,max=11"`
	MinLevel          uint               `json:"min_level" binding:"required,min=1,max=3"`
	BVI               bool               `json:"is_bvi" binding:"required"`
	ConfirmSubjects   []ConfirmSubject   `json:"confirmation_subjects" binding:"required"`
	FullScoreSubjects []FullScoreSubject `json:"full_score_subjects" binding:"required"`
}

type ConfirmSubject struct {
	SubjectID uint `json:"subject_id" binding:"required"`
	Score     uint `json:"score" binding:"required"`
}

type FullScoreSubject struct {
	SubjectID uint `json:"subject_id" binding:"required"`
}
