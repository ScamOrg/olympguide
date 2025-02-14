package repository

import (
	"api/model"
	"gorm.io/gorm"
)

type IProgramRepo interface {
	GetProgramsByFacultyID(facultyID string, userID any) ([]model.Program, error)
	GetLikedPrograms(userID uint) ([]model.Program, error)
	NewProgram(program *model.Program,
		optSubjects []uint, reqSubjects []uint) (uint, error)
	UpdateProgram(program *model.Program) error
	DeleteProgram(program *model.Program) error
	GetProgram(programID string, userID any) (*model.Program, error)
	LikeProgram(programID uint, userID uint) error
	DislikeProgram(programID uint, userID uint) error
	GetSubjects() ([]model.Subject, error)
}

type PgProgramRepo struct {
	db *gorm.DB
}

func NewPgProgramRepo(db *gorm.DB) *PgProgramRepo {
	return &PgProgramRepo{db: db}
}

func (p *PgProgramRepo) GetProgram(programID string, userID any) (*model.Program, error) {
	var program model.Program
	err := p.db.Debug().
		Preload("University").
		Preload("Field").
		Preload("OptionalSubjects").
		Preload("RequiredSubjects").
		Joins("LEFT JOIN olympguide.liked_programs lp "+
			"ON lp.program_id = olympguide.educational_program.program_id AND lp.user_id = ?", userID).
		Select("olympguide.educational_program.*, CASE WHEN lp.user_id IS NOT NULL THEN TRUE ELSE FALSE END as like").
		Where("olympguide.educational_program.program_id = ?", programID).
		First(&program).Error
	return &program, err
}

func (p *PgProgramRepo) GetProgramsByFacultyID(facultyID string, userID any) ([]model.Program, error) {
	var programs []model.Program
	err := p.db.Debug().Preload("OptionalSubjects").Preload("RequiredSubjects").Preload("Field").
		Joins("LEFT JOIN olympguide.liked_programs lp "+
			"ON lp.program_id = olympguide.educational_program.program_id AND lp.user_id = ?", userID).
		Select("olympguide.educational_program.*, CASE WHEN lp.user_id IS NOT NULL THEN TRUE ELSE FALSE END as like").
		Where("faculty_id = ?", facultyID).
		Find(&programs).Error
	return programs, err
}

func (p *PgProgramRepo) GetLikedPrograms(userID uint) ([]model.Program, error) {
	var programs []model.Program
	err := p.db.Debug().
		Preload("OptionalSubjects").
		Preload("RequiredSubjects").
		Preload("Field").
		Preload("University").
		Joins("LEFT JOIN olympguide.liked_programs lp ON lp.program_id = olympguide.educational_program.program_id AND lp.user_id = ?", userID).
		Where("lp.user_id IS NOT NULL").
		Select("olympguide.educational_program.*, TRUE as like").
		Find(&programs).Error
	if err != nil {
		return nil, err
	}
	return programs, nil
}

func (p *PgProgramRepo) NewProgram(program *model.Program,
	optSubjects []uint, reqSubjects []uint) (uint, error) {
	err := p.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Create(program).Error; err != nil {
			return err
		}
		if len(reqSubjects) > 0 {
			requiredSubjects := make([]model.ProgramRequiredSubjects, len(reqSubjects))
			for i, subjectID := range reqSubjects {
				requiredSubjects[i] = model.ProgramRequiredSubjects{
					ProgramID: program.ProgramID,
					SubjectID: subjectID,
				}
			}
			if err := tx.Table("olympguide.program_required_subjects").Create(&requiredSubjects).Error; err != nil {
				return err
			}
		}
		if len(optSubjects) > 0 {
			optionalSubjects := make([]model.ProgramOptionalSubjects, len(optSubjects))
			for i, subjectID := range optSubjects {
				optionalSubjects[i] = model.ProgramOptionalSubjects{
					ProgramID: program.ProgramID,
					SubjectID: subjectID,
				}
			}
			if err := tx.Table("olympguide.program_optional_subjects").Create(&optionalSubjects).Error; err != nil {
				return err
			}
		}
		return nil
	})
	return program.ProgramID, err
}

func (p *PgProgramRepo) UpdateProgram(program *model.Program) error {
	return p.db.Save(program).Error
}

func (p *PgProgramRepo) DeleteProgram(program *model.Program) error {
	return p.db.Delete(program).Error
}

func (p *PgProgramRepo) LikeProgram(programID uint, userID uint) error {
	likedPrograms := model.LikedPrograms{
		ProgramID: programID,
		UserID:    userID,
	}
	err := p.db.Create(&likedPrograms).Error
	return err
}

func (p *PgProgramRepo) DislikeProgram(programID uint, userID uint) error {
	likedPrograms := model.LikedPrograms{
		ProgramID: programID,
		UserID:    userID,
	}
	err := p.db.Delete(&likedPrograms).Error
	return err
}

func (p *PgProgramRepo) GetSubjects() ([]model.Subject, error) {
	var subjects []model.Subject
	if err := p.db.Find(&subjects).Error; err != nil {
		return nil, err
	}
	return subjects, nil
}
