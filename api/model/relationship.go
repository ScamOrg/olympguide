package model

type LikedUniversities struct {
	UniversityID uint `gorm:"primaryKey"`
	UserID       uint `gorm:"primaryKey"`
}

type LikedOlympiads struct {
	OlympiadID uint `gorm:"primaryKey"`
	UserID     uint `gorm:"primaryKey"`
}

type LikedPrograms struct {
	ProgramID uint `gorm:"primaryKey"`
	UserID    uint `gorm:"primaryKey"`
}

type ProgramRequiredSubjects struct {
	ProgramID uint `gorm:"primaryKey"`
	SubjectID uint `gorm:"primaryKey"`
}

type ProgramOptionalSubjects struct {
	ProgramID uint `gorm:"primaryKey, column:program_id"`
	SubjectID uint `gorm:"primaryKey, column:subject_id"`
}

type ConfirmationSubjects struct {
	BenefitID uint `gorm:"primaryKey"`
	SubjectID uint `gorm:"primaryKey"`
	Score     uint
}

type FullScoreSubjects struct {
	BenefitID uint `gorm:"primaryKey"`
	SubjectID uint `gorm:"primaryKey"`
}

func (FullScoreSubjects) TableName() string       { return "olympguide.fullscore_subjects" }
func (ConfirmationSubjects) TableName() string    { return "olympguide.confirmation_subjects" }
func (LikedPrograms) TableName() string           { return "olympguide.liked_programs" }
func (LikedUniversities) TableName() string       { return "olympguide.liked_universities" }
func (LikedOlympiads) TableName() string          { return "olympguide.liked_olympiads" }
func (ProgramRequiredSubjects) TableName() string { return "olympguide.program_required_subjects" }
func (ProgramOptionalSubjects) TableName() string { return "olympguide.program_optional_subjects" }
