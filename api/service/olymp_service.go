package service

import (
	"api/dto"
	"api/model"
	"api/repository"
	"api/utils/constants"
)

type IOlympService interface {
	GetOlymps(params *dto.OlympQueryParams) ([]dto.OlympiadShortResponse, error)
	GetLikedOlymps(userID uint) ([]dto.OlympiadShortResponse, error)
	LikeOlymp(olympiadID string, userID uint) (bool, error)
	DislikeOlymp(olympiadID string, userID uint) (bool, error)
}

type OlympService struct {
	olympRepo repository.IOlympRepo
}

func NewOlympService(olympRepo repository.IOlympRepo) *OlympService {
	return &OlympService{olympRepo: olympRepo}
}

func (o *OlympService) GetOlymps(params *dto.OlympQueryParams) ([]dto.OlympiadShortResponse, error) {
	olymps, err := o.olympRepo.GetOlymps(params)
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

func (o *OlympService) GetOlymp(olympiadID string, userID any) (*dto.OlympiadResponse, error) {
	olymp, err := o.olympRepo.GetOlymp(olympiadID, userID)
	if err != nil {
		return nil, err
	}
	return newOlympResponse(olymp), nil
}

func (o *OlympService) LikeOlymp(olympiadID string, userID uint) (bool, error) {
	olymp, err := o.olympRepo.GetOlymp(olympiadID, userID)
	if err != nil {
		return false, err
	}

	if olymp.Like {
		return false, nil
	}

	err = o.olympRepo.LikeOlymp(olymp.OlympiadID, userID)
	if err != nil {
		return false, err
	}
	o.olympRepo.ChangeOlympPopularity(olymp, constants.LikeOlympPopularIncr)
	return true, nil
}

func (o *OlympService) DislikeOlymp(olympiadID string, userID uint) (bool, error) {
	olymp, err := o.olympRepo.GetOlymp(olympiadID, userID)
	if err != nil {
		return false, err
	}

	if !olymp.Like {
		return false, nil
	}

	err = o.olympRepo.DislikeOlymp(olymp.OlympiadID, userID)
	if err != nil {
		return false, err
	}
	o.olympRepo.ChangeOlympPopularity(olymp, constants.LikeOlympPopularDecr)
	return true, nil
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

func newOlympResponse(olymp *model.Olympiad) *dto.OlympiadResponse {
	return &dto.OlympiadResponse{
		OlympiadShortResponse: dto.OlympiadShortResponse{
			OlympiadID: olymp.OlympiadID,
			Name:       olymp.Name,
			Level:      olymp.Level,
			Profile:    olymp.Profile,
			Like:       olymp.Like,
		},
		Description: olymp.Description,
		Link:        olymp.Link,
	}
}
