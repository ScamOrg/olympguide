package service

import (
	"api/dto"
	"api/model"
	"api/repository"
)

type IProgramService interface {
	GetProgramsByFacultyID(facultyID string, userID any) ([]dto.ProgramInUniverResponse, error)
}

type ProgramService struct {
	programRepo repository.IProgramRepo
}

func NewProgramService(programRepo repository.IProgramRepo) *ProgramService {
	return &ProgramService{programRepo: programRepo}
}

func (p *ProgramService) GetProgramsByFacultyID(facultyID string, userID any) ([]dto.ProgramInUniverResponse, error) {
	programs, err := p.programRepo.GetProgramsByFacultyID(facultyID, userID)
	if err != nil {
		return nil, err
	}
	return newProgramInUniverResponse(programs), nil
}

func (p *ProgramService) GetProgram(programID string, userID any) (*dto.ProgramResponse, error) {
	program, err := p.programRepo.GetProgram(programID, userID)
	if err != nil {
		return nil, err
	}
	return newProgramResponse(program), nil
}

func newProgramInUniverResponse(programs []model.Program) []dto.ProgramInUniverResponse {
	var response []dto.ProgramInUniverResponse

	for _, program := range programs {
		requiredSubjects := make([]string, len(program.RequiredSubjects))
		for i, s := range program.RequiredSubjects {
			requiredSubjects[i] = s.Name
		}

		optionalSubjects := make([]string, len(program.OptionalSubjects))
		for i, s := range program.OptionalSubjects {
			optionalSubjects[i] = s.Name
		}

		response = append(response, dto.ProgramInUniverResponse{
			ProgramID:        program.ProgramID,
			Name:             program.Name,
			Field:            program.Field.Code,
			BudgetPlaces:     program.BudgetPlaces,
			PaidPlaces:       program.PaidPlaces,
			Cost:             program.Cost,
			Like:             program.Like,
			RequiredSubjects: requiredSubjects,
			OptionalSubjects: optionalSubjects,
		})
	}

	return response
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
		ProgramID:        program.ProgramID,
		Name:             program.Name,
		Field:            program.Field.Code,
		BudgetPlaces:     program.BudgetPlaces,
		PaidPlaces:       program.PaidPlaces,
		Cost:             program.Cost,
		Like:             program.Like,
		RequiredSubjects: requiredSubjects,
		OptionalSubjects: optionalSubjects,
		University:       *newUniverResponse(&program.University),
	}
}
