package service

import (
	"api/dto"
	"api/model"
	"api/repository"
	"api/utils/constants"
	"strconv"
)

type IUniverService interface {
	GetUniver(universityID string, userID any) (*dto.UniversityResponse, error)
	GetUnivers(params *dto.UniversityQueryParams) ([]dto.UniversityShortResponse, error)
	GetLikedUnivers(userID uint) ([]dto.UniversityShortResponse, error)
	NewUniver(request *dto.UniversityRequest) (uint, error)
	UpdateUniver(request *dto.UniversityRequest, universityID string) (uint, error)
	DeleteUniver(universityID string) error
	LikeUniver(universityID string, userID uint) (bool, error)
	DislikeUniver(universityID string, userID uint) (bool, error)
}

type UniverService struct {
	univerRepo repository.IUniverRepo
	regionRepo repository.IRegionRepo
}

func NewUniverService(univerRepo repository.IUniverRepo, regionRepo repository.IRegionRepo) *UniverService {
	return &UniverService{univerRepo: univerRepo, regionRepo: regionRepo}
}

func (u *UniverService) GetUniver(universityID string, userID any) (*dto.UniversityResponse, error) {
	univer, err := u.univerRepo.GetUniver(universityID, userID)
	if err != nil {
		return nil, err
	}
	return newUniverResponse(univer), nil
}

func (u *UniverService) GetUnivers(params *dto.UniversityQueryParams) ([]dto.UniversityShortResponse, error) {
	if uintUserID, ok := params.UserID.(uint); ok && params.FromMyRegion {
		region, err := u.regionRepo.GetUserRegion(uintUserID)
		if err != nil {
			return nil, err
		}
		params.RegionIDs = []string{strconv.Itoa(int(region.RegionID))}
	}

	univers, err := u.univerRepo.GetUnivers(params.Search, params.RegionIDs, params.UserID)
	if err != nil {
		return nil, err
	}

	return newUniversShortResponse(univers), nil
}

func (u *UniverService) GetLikedUnivers(userID uint) ([]dto.UniversityShortResponse, error) {
	univers, err := u.univerRepo.GetLikedUnivers(userID)
	if err != nil {
		return nil, err
	}
	return newUniversShortResponse(univers), nil
}

func (u *UniverService) NewUniver(request *dto.UniversityRequest) (uint, error) {
	univerModel := newUniverModel(request)
	return u.univerRepo.NewUniver(univerModel)
}

func (u *UniverService) UpdateUniver(request *dto.UniversityRequest, universityID string) (uint, error) {
	university, err := u.univerRepo.GetUniver(universityID, nil)
	if err != nil {
		return 0, err
	}

	univerModel := newUniverModel(request)
	univerModel.UniversityID = university.UniversityID
	err = u.univerRepo.UpdateUniver(univerModel)

	if err != nil {
		return 0, err
	}
	return university.UniversityID, nil
}

func (u *UniverService) DeleteUniver(universityID string) error {
	univer, err := u.univerRepo.GetUniver(universityID, nil)
	if err != nil {
		return err
	}
	return u.univerRepo.DeleteUniver(univer)
}

func (u *UniverService) LikeUniver(universityID string, userID uint) (bool, error) {
	university, err := u.univerRepo.GetUniver(universityID, userID)
	if err != nil {
		return false, err
	}

	if university.Like {
		return false, nil
	}

	err = u.univerRepo.LikeUniver(university.UniversityID, userID)
	if err != nil {
		return false, err
	}
	u.univerRepo.ChangeUniverPopularity(university, constants.LikeUniverPopularIncr)
	return true, nil
}

func (u *UniverService) DislikeUniver(universityID string, userID uint) (bool, error) {
	university, err := u.univerRepo.GetUniver(universityID, userID)
	if err != nil {
		return false, err
	}

	if !university.Like {
		return false, nil
	}

	err = u.univerRepo.DislikeUniver(university.UniversityID, userID)
	if err != nil {
		return false, err
	}
	u.univerRepo.ChangeUniverPopularity(university, constants.LikeUniverPopularDecr)
	return true, nil
}

func newUniverModel(request *dto.UniversityRequest) *model.University {
	return &model.University{
		Name:        request.Name,
		Logo:        request.Logo,
		Site:        request.Site,
		Email:       request.Email,
		Description: request.Description,
		RegionID:    request.RegionID,
	}
}

func newUniverResponse(univer *model.University) *dto.UniversityResponse {
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

func newUniversShortResponse(univers []model.University) []dto.UniversityShortResponse {
	var response []dto.UniversityShortResponse
	for _, univer := range univers {
		response = append(response, dto.UniversityShortResponse{
			UniversityID: univer.UniversityID,
			Name:         univer.Name,
			Logo:         univer.Logo,
			Region:       univer.Region.Name,
			Like:         univer.Like,
		})
	}
	return response
}
