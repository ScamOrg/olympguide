package service

import (
	"api/dto"
	"api/model"
	"api/repository"
	"api/utils/errs"
)

type IProgramService interface {
	GetProgramsByFacultyID(facultyID string, userID any) ([]dto.ProgramShortResponse, error)
	LikeProgram(programID string, userID uint) (bool, error)
	DislikeProgram(programID string, userID uint) (bool, error)
	GetLikedPrograms(userID uint) ([]dto.ProgramResponse, error)
	GetProgram(programID string, userID any) (*dto.ProgramResponse, error)
	NewProgram(request *dto.ProgramRequest) (uint, error)
}

type ProgramService struct {
	programRepo repository.IProgramRepo
	univerRepo  repository.IUniverRepo
	facultyRepo repository.IFacultyRepo
	fieldRepo   repository.IFieldRepo
}

func NewProgramService(programRepo repository.IProgramRepo,
	univerRepo repository.IUniverRepo,
	facultyRepo repository.IFacultyRepo,
	fieldRepo repository.IFieldRepo) *ProgramService {
	return &ProgramService{programRepo: programRepo, univerRepo: univerRepo, facultyRepo: facultyRepo, fieldRepo: fieldRepo}
}

func (p *ProgramService) GetProgramsByFacultyID(facultyID string, userID any) ([]dto.ProgramShortResponse, error) {
	programs, err := p.programRepo.GetProgramsByFacultyID(facultyID, userID)
	if err != nil {
		return nil, err
	}
	response := make([]dto.ProgramShortResponse, len(programs))
	for i, program := range programs {
		response[i] = *newProgramShortResponse(&program)
	}
	return response, nil
}

func (p *ProgramService) GetProgram(programID string, userID any) (*dto.ProgramResponse, error) {
	program, err := p.programRepo.GetProgram(programID, userID)
	if err != nil {
		return nil, err
	}
	return newProgramResponse(program), nil
}

func (p *ProgramService) GetLikedPrograms(userID uint) ([]dto.ProgramResponse, error) {
	programs, err := p.programRepo.GetLikedPrograms(userID)
	if err != nil {
		return nil, err
	}
	response := make([]dto.ProgramResponse, len(programs))
	for i, program := range programs {
		response[i] = *newProgramResponse(&program)
	}
	return response, nil
}

func (p *ProgramService) NewProgram(request *dto.ProgramRequest) (uint, error) {
	program := newProgramModel(request)

	if !p.univerRepo.Exists(program.UniversityID) {
		return 0, errs.UniversityNotExist
	}

	if !p.facultyRepo.ExistsInUniversity(program.FacultyID, program.UniversityID) {
		return 0, errs.FacultyErr
	}

	if !p.fieldRepo.Exists(program.FieldID) {
		return 0, errs.FieldNotExist
	}

	return p.programRepo.NewProgram(program, request.OptionalSubjects, request.RequiredSubjects)
}

func (p *ProgramService) LikeProgram(programID string, userID uint) (bool, error) {
	program, err := p.programRepo.GetProgram(programID, userID)
	if err != nil {
		return false, err
	}

	if program.Like {
		return false, nil
	}

	err = p.programRepo.LikeProgram(program.ProgramID, userID)
	if err != nil {
		return false, err
	}
	return true, nil
}

func (p *ProgramService) DislikeProgram(programID string, userID uint) (bool, error) {
	program, err := p.programRepo.GetProgram(programID, userID)
	if err != nil {
		return false, err
	}

	if !program.Like {
		return false, nil
	}

	err = p.programRepo.DislikeProgram(program.ProgramID, userID)
	if err != nil {
		return false, err
	}

	return true, nil
}

func newProgramShortResponse(program *model.Program) *dto.ProgramShortResponse {
	requiredSubjects := make([]string, len(program.RequiredSubjects))
	for i, s := range program.RequiredSubjects {
		requiredSubjects[i] = s.Name
	}
	optionalSubjects := make([]string, len(program.OptionalSubjects))
	for i, s := range program.OptionalSubjects {
		optionalSubjects[i] = s.Name
	}

	return &dto.ProgramShortResponse{
		ProgramID:        program.ProgramID,
		Name:             program.Name,
		Field:            program.Field.Code,
		BudgetPlaces:     program.BudgetPlaces,
		PaidPlaces:       program.PaidPlaces,
		Cost:             program.Cost,
		Like:             program.Like,
		RequiredSubjects: requiredSubjects,
		OptionalSubjects: optionalSubjects,
	}
}

func newProgramResponse(program *model.Program) *dto.ProgramResponse {
	requiredSubjects := make([]string, len(program.RequiredSubjects))
	for i, s := range program.RequiredSubjects {
		requiredSubjects[i] = s.Name
	}

	optionalSubjects := make([]string, len(program.OptionalSubjects))
	for i, s := range program.OptionalSubjects {
		optionalSubjects[i] = s.Name
	}

	return &dto.ProgramResponse{
		ProgramShortResponse: *newProgramShortResponse(program),
		University: dto.UniversityForProgramInfo{
			UniversityID: program.UniversityID,
			Name:         program.University.Name,
			Logo:         program.University.Logo,
		},
	}
}

func newProgramModel(request *dto.ProgramRequest) *model.Program {
	return &model.Program{
		Name:         request.Name,
		BudgetPlaces: request.BudgetPlaces,
		PaidPlaces:   request.PaidPlaces,
		Cost:         request.Cost,
		Link:         request.Link,
		UniversityID: request.UniversityID,
		FieldID:      request.FieldID,
		FacultyID:    request.FacultyID,
	}
}

func newOptionalProgramModels(programID uint, SubjectIDs []uint) []model.ProgramOptionalSubjects {
	set := make(map[uint]struct{}, len(SubjectIDs))
	for _, id := range SubjectIDs {
		set[id] = struct{}{}
	}
	optionalSubjects := make([]model.ProgramOptionalSubjects, 0, len(set))
	for subjectID := range set {
		optionalSubjects = append(optionalSubjects, model.ProgramOptionalSubjects{
			ProgramID: programID,
			SubjectID: subjectID,
		})
	}
	return optionalSubjects
}

func newRequiredProgramModels(programID uint, subjectIDs []uint) []model.ProgramRequiredSubjects {
	set := make(map[uint]struct{}, len(subjectIDs))
	for _, id := range subjectIDs {
		set[id] = struct{}{}
	}
	requiredSubjects := make([]model.ProgramRequiredSubjects, 0, len(set))
	for subjectID := range set {
		requiredSubjects = append(requiredSubjects, model.ProgramRequiredSubjects{
			ProgramID: programID,
			SubjectID: subjectID,
		})
	}
	return requiredSubjects
}
