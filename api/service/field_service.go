package service

import (
	"api/dto"
	"api/model"
	"api/repository"
)

type IFieldService interface {
	GetField(fieldID string) (*dto.FieldResponse, error)
	GetGroups(params dto.GroupQueryParams) ([]dto.GroupResponse, error)
}

type FieldService struct {
	fieldRepo repository.IFieldRepo
}

func NewFieldService(fieldRepo repository.IFieldRepo) *FieldService {
	return &FieldService{fieldRepo: fieldRepo}
}

func (s *FieldService) GetField(fieldID string) (*dto.FieldResponse, error) {
	field, err := s.fieldRepo.GetField(fieldID)
	if err != nil {
		return nil, err
	}
	return newFieldResponse(field), nil
}

func (s *FieldService) GetGroups(params dto.GroupQueryParams) ([]dto.GroupResponse, error) {
	groups, err := s.fieldRepo.GetGroups(params.Search, params.Degrees)
	if err != nil {
		return nil, err
	}
	return newGroupsResponse(groups), nil
}

func newFieldResponse(field *model.Field) *dto.FieldResponse {
	return &dto.FieldResponse{
		FieldID: field.FieldID,
		Name:    field.Name,
		Code:    field.Code,
		Degree:  field.Degree,
		Group: dto.GroupShortInfo{
			Name: field.Group.Name,
			Code: field.Group.Code,
		},
	}
}

func newGroupsResponse(groups []model.GroupField) []dto.GroupResponse {
	var response []dto.GroupResponse

	for _, group := range groups {
		if len(group.Fields) == 0 {
			continue
		}
		var fields []dto.FieldShortInfo
		for _, field := range group.Fields {
			fields = append(fields, dto.FieldShortInfo{
				FieldID: field.FieldID,
				Name:    field.Name,
				Code:    field.Code,
				Degree:  field.Degree,
			})
		}
		response = append(response, dto.GroupResponse{
			Name:   group.Name,
			Code:   group.Code,
			Fields: fields,
		})
	}

	return response
}
