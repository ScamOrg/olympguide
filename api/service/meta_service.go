package service

import (
	"api/dto"
	"api/model"
	"api/repository"
)

type IMetaService interface {
	GetRegions() ([]dto.RegionResponse, error)
	GetUniversityRegions() ([]dto.RegionResponse, error)
	GetOlympiadProfiles() ([]string, error)
	GetSubjects() ([]dto.SubjectResponse, error)
}

type MetaService struct {
	regionRepo  repository.IRegionRepo
	olympRepo   repository.IOlympRepo
	programRepo repository.IProgramRepo
}

func NewMetaService(regionRepo repository.IRegionRepo, olympRepo repository.IOlympRepo, programRepo repository.IProgramRepo) *MetaService {
	return &MetaService{regionRepo: regionRepo, olympRepo: olympRepo, programRepo: programRepo}
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

func (s *MetaService) GetSubjects() ([]dto.SubjectResponse, error) {
	subjects, err := s.programRepo.GetSubjects()
	if err != nil {
		return nil, err
	}
	return newSubjectsResponse(subjects), nil
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

func newSubjectsResponse(subjects []model.Subject) []dto.SubjectResponse {
	var response []dto.SubjectResponse
	for _, subject := range subjects {
		response = append(response, dto.SubjectResponse{
			SubjectID: subject.SubjectID,
			Name:      subject.Name,
		})
	}
	return response
}
