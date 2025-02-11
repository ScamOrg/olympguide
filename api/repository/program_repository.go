package repository

import (
	"api/model"
	"gorm.io/gorm"
)

type IProgramRepo interface {
	GetProgramsByFacultyID(facultyID string, userID any) ([]model.Program, error)
	NewProgram(program *model.Program) (uint, error)
	UpdateProgram(program *model.Program) error
	DeleteProgram(program *model.Program) error
	GetProgram(programID string, userID any) (*model.Program, error)
}

type PgProgramRepo struct {
	db *gorm.DB
}

func NewPgProgramRepo(db *gorm.DB) *PgProgramRepo {
	return &PgProgramRepo{db: db}
}

func (p *PgProgramRepo) GetProgram(programID string, userID any) (*model.Program, error) {
	var program model.Program
	err := p.db.Debug().Preload("University").Preload("Field").Preload("Subjects").
		Joins("LEFT JOIN olympguide.liked_programs lp "+
			"ON lp.program_id = olympguide.educational_program.program_id AND lp.user_id = ?", userID).
		Where("olympguide.educational_program.program_id = ?", programID).
		First(&program).Error
	return &program, err
}

func (p *PgProgramRepo) GetProgramsByFacultyID(facultyID string, userID any) ([]model.Program, error) {
	var programs []model.Program
	err := p.db.Debug().Preload("Field").Preload("Subjects").
		Joins("LEFT JOIN olympguide.liked_programs lp "+
			"ON lp.program_id = olympguide.educational_program.program_id AND lp.user_id = ?", userID).
		Select("olympguide.program.*, CASE WHEN lp.user_id IS NOT NULL THEN TRUE ELSE FALSE END as like").
		Where("faculty_id = ?", facultyID).
		Find(&programs).Error
	return programs, err
}

func (p *PgProgramRepo) NewProgram(program *model.Program) (uint, error) {
	if err := p.db.Create(&program).Error; err != nil {
		return 0, err
	}
	return program.ProgramID, nil
}

func (p *PgProgramRepo) UpdateProgram(program *model.Program) error {
	return p.db.Save(program).Error
}

func (p *PgProgramRepo) DeleteProgram(program *model.Program) error {
	return p.db.Delete(program).Error
}
