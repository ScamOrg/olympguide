package service

import (
	"api/dto"
	"api/model"
	"api/repository"
	"api/utils/errs"
)

type IProgramService interface {
	GetProgramsByFacultyID(facultyID string, userID any) ([]dto.ProgramShortResponse, error)
	GetUniverProgramsByFaculty(univerID string, userID any) ([]dto.FacultyProgramTree, error)
	GetUniverProgramsByField(univerID string, userID any) ([]dto.GroupProgramTree, error)
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

	if !p.facultyRepo.ExistsInUniversity(program.FacultyID, program.UniversityID) {
		return 0, errs.FacultyNotInUniversity
	}

	return p.programRepo.NewProgram(program)
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

func (p *ProgramService) GetUniverProgramsByFaculty(univerID string, userID any) ([]dto.FacultyProgramTree, error) {
	programs, err := p.programRepo.GetUniverProgramsWithFaculty(univerID, userID)
	if err != nil {
		return nil, err
	}
	return newFacultyProgramTree(programs), nil
}

func (p *ProgramService) GetUniverProgramsByField(univerID string, userID any) ([]dto.GroupProgramTree, error) {
	programs, err := p.programRepo.GetUniverProgramsWithGroup(univerID, userID)
	if err != nil {
		return nil, err
	}
	return newGroupProgramTree(programs), nil
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
		Link: program.Link,
	}
}

func newProgramModel(request *dto.ProgramRequest) *model.Program {
	program := model.Program{
		Name:             request.Name,
		BudgetPlaces:     request.BudgetPlaces,
		PaidPlaces:       request.PaidPlaces,
		Cost:             request.Cost,
		Link:             request.Link,
		UniversityID:     request.UniversityID,
		FieldID:          request.FieldID,
		FacultyID:        request.FacultyID,
		OptionalSubjects: make([]model.Subject, len(request.OptionalSubjects)),
		RequiredSubjects: make([]model.Subject, len(request.RequiredSubjects)),
	}

	for i := range request.OptionalSubjects {
		program.OptionalSubjects[i] = model.Subject{
			SubjectID: request.OptionalSubjects[i],
		}
	}

	for i := range request.RequiredSubjects {
		program.RequiredSubjects[i] = model.Subject{
			SubjectID: request.RequiredSubjects[i],
		}
	}
	return &program
}

func newFacultyProgramTree(programs []model.Program) []dto.FacultyProgramTree {
	facultyMap := make(map[uint]*dto.FacultyProgramTree)
	for i := range programs {
		if _, ok := facultyMap[programs[i].FacultyID]; !ok {
			facultyMap[programs[i].FacultyID] = &dto.FacultyProgramTree{
				FacultyID: programs[i].FacultyID,
				Name:      programs[i].Faculty.Name,
				Programs:  []dto.ProgramShortResponse{},
			}
		}

		facultyMap[programs[i].FacultyID].Programs = append(facultyMap[programs[i].FacultyID].Programs,
			*newProgramShortResponse(&programs[i]))
	}
	facultyProgramTrees := make([]dto.FacultyProgramTree, 0, len(facultyMap)) // Предварительное выделение памяти
	for _, facultyResponse := range facultyMap {
		facultyProgramTrees = append(facultyProgramTrees, *facultyResponse)
	}
	return facultyProgramTrees
}

func newGroupProgramTree(programs []model.Program) []dto.GroupProgramTree {
	groupMap := make(map[uint]*dto.GroupProgramTree)
	for i := range programs {
		if _, ok := groupMap[programs[i].Field.GroupID]; !ok {
			groupMap[programs[i].Field.GroupID] = &dto.GroupProgramTree{
				GroupID:  programs[i].Field.GroupID,
				Name:     programs[i].Field.Name,
				Code:     programs[i].Field.Code,
				Programs: []dto.ProgramShortResponse{},
			}
		}

		groupMap[programs[i].Field.GroupID].Programs = append(groupMap[programs[i].Field.GroupID].Programs,
			*newProgramShortResponse(&programs[i]))
	}
	groupProgramTrees := make([]dto.GroupProgramTree, 0, len(groupMap))
	for _, groupResponse := range groupMap {
		groupProgramTrees = append(groupProgramTrees, *groupResponse)
	}
	return groupProgramTrees
}
