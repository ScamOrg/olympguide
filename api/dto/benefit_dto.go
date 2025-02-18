package dto

type BenefitRequest struct {
	OlympiadID        uint                `json:"olympiad_id" binding:"required"`
	ProgramID         uint                `json:"program_id" binding:"required"`
	MinClass          uint                `json:"min_class" binding:"required,min=9,max=11"`
	MinDiplomaLevel   uint                `json:"min_diploma_level" binding:"required,min=1,max=3"`
	BVI               bool                `json:"is_bvi"`
	ConfirmSubjects   []ConfirmSubjectReq `json:"confirmation_subjects" binding:"required"`
	FullScoreSubjects []uint              `json:"full_score_subjects"`
}

type ConfirmSubjectReq struct {
	SubjectID uint `json:"subject_id" binding:"required"`
	Score     uint `json:"score" binding:"required"`
}

type ConfirmSubjectResp struct {
	Subject string `json:"subject"`
	Score   uint   `json:"score"`
}

type BenefitInfo struct {
	MinClass          uint                 `json:"min_class"`
	MinDiplomaLevel   uint                 `json:"min_diploma_level"`
	BVI               bool                 `json:"is_bvi"`
	ConfirmSubjects   []ConfirmSubjectResp `json:"confirmation_subjects"`
	FullScoreSubjects []string             `json:"full_score_subjects"`
}

type OlympiadBenefitTree struct {
	Olympiad OlympiadBenefitInfo `json:"olympiad"`
	Benefits []BenefitInfo       `json:"benefits"`
}

type ProgramBenefitTree struct {
	Program  ProgramBenefitInfo `json:"program"`
	Benefits []BenefitInfo      `json:"benefits"`
}
