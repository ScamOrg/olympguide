package service

import (
	"api/dto"
	"api/model"
	"api/repository"
)

type IUniverService interface {
	GetUniver(universityID string, userID any) (*dto.UniversityResponse, error)
}

type UniverService struct {
	univerRepo repository.IUniverRepo
}

func NewUniverService(univerRepo repository.IUniverRepo) *UniverService {
	return &UniverService{univerRepo: univerRepo}
}

func (u *UniverService) GetUniver(universityID string, userID any) (*dto.UniversityResponse, error) {
	univer, err := u.univerRepo.GetUniver(universityID, userID)
	if err != nil {
		return nil, err
	}
	return newUniversityResponse(univer), nil
}

func newUniversityResponse(univer *model.University) *dto.UniversityResponse {
	return &dto.UniversityResponse{
		Email:       univer.Email,
		Site:        univer.Site,
		Description: univer.Description,
		UniversityShortResponse: dto.UniversityShortResponse{
			UniversityID: univer.UniversityID,
			Name:         univer.Name,
			Logo:         univer.Logo,
			Region:       univer.Region.Name,
			Like:         univer.Like,
		},
	}
}
