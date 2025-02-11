package service

import (
	"api/dto"
	"api/model"
	"api/repository"
	"api/utils/errs"
)

type IFacultyService interface {
	NewFaculty(request *dto.FacultyRequest) (uint, error)
	UpdateFaculty(request *dto.FacultyRequest, facultyID string) (uint, error)
	DeleteFaculty(facultyID string) error
	GetFaculties(universityID string) ([]dto.FacultyShortResponse, error)
}

type FacultyService struct {
	facultyRepo repository.IFacultyRepo
	univerRepo  repository.IUniverRepo
}

func NewFacultyService(facultyRepo repository.IFacultyRepo) *FacultyService {
	return &FacultyService{facultyRepo: facultyRepo}
}

func (u *FacultyService) NewFaculty(request *dto.FacultyRequest) (uint, error) {
	facultyModel := newFacultyModel(request)
	exists := u.univerRepo.UniverExists(facultyModel.UniversityID)
	if !exists {
		return 0, errs.UniversityNotExist
	}
	return u.facultyRepo.NewFaculty(facultyModel)
}

func (u *FacultyService) UpdateFaculty(request *dto.FacultyRequest, facultyID string) (uint, error) {
	faculty, err := u.facultyRepo.GetFacultyByID(facultyID)
	if err != nil {
		return 0, err
	}

	facultyModel := newFacultyModel(request)
	facultyModel.FacultyID = faculty.FacultyID
	err = u.facultyRepo.UpdateFaculty(facultyModel)
	if err != nil {
		return 0, err
	}
	return faculty.FacultyID, nil
}

func (u *FacultyService) DeleteFaculty(facultyID string) error {
	faculty, err := u.facultyRepo.GetFacultyByID(facultyID)
	if err != nil {
		return err
	}
	return u.facultyRepo.DeleteFaculty(faculty)
}

func (u *FacultyService) GetFaculties(universityID string) ([]dto.FacultyShortResponse, error) {
	faculties, err := u.facultyRepo.GetFacultiesByUniversityID(universityID)
	if err != nil {
		return nil, err
	}
	return newFacultiesShortResponse(faculties), nil
}

func newFacultyModel(request *dto.FacultyRequest) *model.Faculty {
	return &model.Faculty{
		Name:         request.Name,
		Description:  request.Description,
		UniversityID: request.UniversityID,
	}
}

func newFacultiesShortResponse(faculties []model.Faculty) []dto.FacultyShortResponse {
	response := make([]dto.FacultyShortResponse, len(faculties))
	for i, faculty := range faculties {
		response[i] = dto.FacultyShortResponse{
			FacultyID: faculty.FacultyID,
			Name:      faculty.Name,
		}
	}
	return response
}
