package repository

import (
	"api/dto"
	"api/model"
	"gorm.io/gorm"
)

type IProgramRepo interface {
	GetProgramsByFacultyID(facultyID string, userID any) ([]model.Program, error)
	GetLikedPrograms(userID uint) ([]model.Program, error)
	NewProgram(program *model.Program) (uint, error)
	UpdateProgram(program *model.Program) error
	DeleteProgram(program *model.Program) error
	GetProgram(programID string, userID any) (*model.Program, error)
	LikeProgram(programID uint, userID uint) error
	DislikeProgram(programID uint, userID uint) error
	GetSubjects() ([]model.Subject, error)
	GetUniverProgramsWithFaculty(univerID string, userID any, params *dto.ProgramTreeQueryParams) ([]model.Program, error)
	GetUniverProgramsWithGroup(univerID string, userID any, params *dto.ProgramTreeQueryParams) ([]model.Program, error)
	ChangeProgramPopularity(program *model.Program, value int)
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

func (p *PgProgramRepo) GetUniverProgramsWithFaculty(univerID string, userID any, params *dto.ProgramTreeQueryParams) ([]model.Program, error) {
	var programs []model.Program
	query := p.db.Preload("OptionalSubjects").
		Preload("RequiredSubjects").
		Preload("Field").
		Preload("Faculty").
		Joins("LEFT JOIN olympguide.liked_programs lp ON lp.program_id = olympguide.educational_program.program_id AND lp.user_id = ?", userID).
		Select("olympguide.educational_program.*, CASE WHEN lp.user_id IS NOT NULL THEN TRUE ELSE FALSE END as like").
		Where("university_id = ?", univerID)

	if params.Search != "" {
		query = query.Where("faculty.name ILIKE ? ", "%"+params.Search+"%")
	}

	applyProgramTreeFilters(query, params)
	err := query.Order("faculty_id, field_id").
		Find(&programs).Error
	return programs, err
}

func (p *PgProgramRepo) GetUniverProgramsWithGroup(univerID string, userID any, params *dto.ProgramTreeQueryParams) ([]model.Program, error) {
	var programs []model.Program
	query := p.db.Preload("OptionalSubjects").
		Preload("RequiredSubjects").
		Preload("Field").
		Preload("Field.Group").
		Joins("LEFT JOIN olympguide.liked_programs lp ON lp.program_id = olympguide.educational_program.program_id AND lp.user_id = ?", userID).
		Joins("LEFT JOIN olympguide.field_of_study f ON f.field_id = olympguide.educational_program.field_id").
		Select("olympguide.educational_program.*, CASE WHEN lp.user_id IS NOT NULL THEN TRUE ELSE FALSE END as like").
		Where("university_id = ?", univerID)

	if params.Search != "" {
		query = query.Where("field.group.code ILIKE ? OR field.group.name ILIKE ?",
			"%"+params.Search+"%", "%"+params.Search+"%")
	}

	applyProgramTreeFilters(query, params)
	err := query.Order("f.group_id, f.code").Find(&programs).Error
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

func (p *PgProgramRepo) NewProgram(program *model.Program) (uint, error) {
	err := p.db.Create(program).Error
	if err != nil {
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

func (p *PgProgramRepo) ChangeProgramPopularity(program *model.Program, value int) {
	program.Popularity += value
	p.db.Save(program)
}

func applyProgramTreeFilters(query *gorm.DB, params *dto.ProgramTreeQueryParams) *gorm.DB {
	if len(params.Degrees) > 0 {
		query = query.Where("f.degree IN (?)", params.Degrees)
	}

	if params.Search != "" {
		query = query.Where("name ILIKE ? OR field.name ILIKE ? OR field.code ILIKE ?",
			"%"+params.Search+"%", "%"+params.Search+"%", "%"+params.Search+"%")
	}

	if len(params.Subjects) > 0 {
		query = query.Where("NOT EXISTS "+
			"(SELECT 1 FROM olympguide.program_required_subjects prs "+
			"JOIN olympguide.subjects rs ON rs.subject_id = prs.subject_id "+
			"WHERE prs.program_id = olympguide.educational_program.program_id AND rs.name NOT IN (?))",
			params.Subjects)
		query = query.Where("EXISTS "+
			"(SELECT 1 FROM olympguide.program_optional_subjects pos "+
			"JOIN olympguide.subjects os ON os.subject_id = pos.subject_id "+
			"WHERE pos.program_id = olympguide.educational_program.program_id AND os.name IN (?))",
			params.Subjects)
	}
	return query
}
