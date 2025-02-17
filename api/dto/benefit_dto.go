package dto

type BenefitRequest struct {
	OlympiadID uint `json:"olympiad_id" binding:"required"`
	ProgramID  uint `json:"program_id" binding:"required"`
	MinClass   uint `json:"min_class" binding:"required,min=9,max=11"`
	MinLevel   uint `json:"min_level" binding:"required,min=1,max=3"`
	BVI        bool `json:"bvi" binding:"required"`
}
