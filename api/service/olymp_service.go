package service

import (
	"api/dto"
	"api/model"
	"api/repository"
)

type IOlympService interface {
	GetOlymps(params *dto.OlympQueryParams) ([]dto.OlympiadShortResponse, error)
	GetLikedOlymps(userID uint) ([]dto.OlympiadShortResponse, error)
}

type OlympService struct {
	olympRepo repository.IOlympRepo
}

func NewOlympService(olympRepo repository.IOlympRepo) *OlympService {
	return &OlympService{olympRepo: olympRepo}
}

func (o *OlympService) GetOlymps(params *dto.OlympQueryParams) ([]dto.OlympiadShortResponse, error) {
	olymps, err := o.olympRepo.GetOlympiads(params)
	if err != nil {
		return nil, err
	}
	return newOlympsShortResponse(olymps), nil
}

func (o *OlympService) GetLikedOlymps(userID uint) ([]dto.OlympiadShortResponse, error) {
	olymps, err := o.olympRepo.GetLikedOlymps(userID)
	if err != nil {
		return nil, err
	}
	return newOlympsShortResponse(olymps), nil
}

func newOlympsShortResponse(olymps []model.Olympiad) []dto.OlympiadShortResponse {
	var response []dto.OlympiadShortResponse
	for _, olympiad := range olymps {
		response = append(response, dto.OlympiadShortResponse{
			OlympiadID: olympiad.OlympiadID,
			Name:       olympiad.Name,
			Level:      olympiad.Level,
			Profile:    olympiad.Profile,
			Like:       olympiad.Like,
		})
	}
	return response
}
