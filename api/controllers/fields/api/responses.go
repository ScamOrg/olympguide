package api

import (
	"api/logic"
	"api/models"
)

type FieldShortInfo struct {
	FieldID uint   `json:"field_id"`
	Name    string `json:"name"`
	Code    string `json:"code"`
	Degree  string `json:"degree"`
	Like    bool   `json:"like"`
}
type GroupResponse struct {
	Name   string           `json:"name"`
	Code   string           `json:"code"`
	Fields []FieldShortInfo `json:"fields"`
}

type GroupShortInfo struct {
	Name string `json:"name"`
	Code string `json:"code"`
}

type FieldResponse struct {
	FieldID uint           `json:"field_id"`
	Name    string         `json:"name"`
	Code    string         `json:"code"`
	Degree  string         `json:"degree"`
	Like    bool           `json:"like"`
	Group   GroupShortInfo `json:"group"`
}

func CreateGroupResponse(groups []models.GroupField, userID any) []GroupResponse {
	var response []GroupResponse

	for _, group := range groups {
		if len(group.Fields) == 0 {
			continue
		}
		var fields []FieldShortInfo
		for _, field := range group.Fields {
			like := logic.IsUserLikedField(userID, field.FieldID)
			fields = append(fields, FieldShortInfo{
				FieldID: field.FieldID,
				Name:    field.Name,
				Code:    field.Code,
				Degree:  field.Degree,
				Like:    like,
			})
		}
		response = append(response, GroupResponse{
			Name:   group.Name,
			Code:   group.Code,
			Fields: fields,
		})
	}
	return response
}

func CreateFieldResponse(field *models.Field, userID any) FieldResponse {
	like := logic.IsUserLikedField(userID, field.FieldID)
	return FieldResponse{
		FieldID: field.FieldID,
		Name:    field.Name,
		Code:    field.Code,
		Degree:  field.Degree,
		Like:    like,
		Group: GroupShortInfo{
			Name: field.Group.Name,
			Code: field.Group.Code,
		},
	}
}
