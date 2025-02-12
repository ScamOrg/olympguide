package service

import (
	"api/dto"
	"api/model"
	"api/repository"
)

type IMetaService interface {
	GetRegions() ([]model.Region, error)
	GetUniversityRegions() ([]model.Region, error)
	GetOlympiadProfiles() ([]string, error)
}

type MetaService struct {
	regionRepo repository.IRegionRepo
	olympRepo  repository.IOlympRepo
}

func NewMetaService(regionRepo repository.IRegionRepo, olympRepo repository.IOlympRepo) *MetaService {
	return &MetaService{regionRepo: regionRepo, olympRepo: olympRepo}
}

func (s *MetaService) GetRegions() ([]dto.RegionResponse, error) {
	regions, err := s.regionRepo.GetRegions()
	if err != nil {
		return nil, err
	}
	return newRegionsResponse(regions), nil
}

func (s *MetaService) GetUniversityRegions() ([]dto.RegionResponse, error) {
	regions, err := s.regionRepo.GetUniversityRegions()
	if err != nil {
		return nil, err
	}
	return newRegionsResponse(regions), nil
}

func (s *MetaService) GetOlympiadProfiles() ([]string, error) {
	return s.olympRepo.GetOlympiadProfiles()
}

func newRegionsResponse(regions []model.Region) []dto.RegionResponse {
	var response []dto.RegionResponse
	for _, region := range regions {
		response = append(response, dto.RegionResponse{
			RegionID: region.RegionID,
			Name:     region.Name,
		})
	}
	return response
}
