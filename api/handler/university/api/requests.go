package api

import (
	"api/model"
	"github.com/gin-gonic/gin"
)

func CreateUniversityFromRequest(request UniversityRequest) model.University {
	return model.University{
		Name:        request.Name,
		Logo:        request.Logo,
		Site:        request.Site,
		Email:       request.Email,
		Description: request.Description,
		RegionID:    request.RegionID,
	}
}

func UpdateUniversityFromRequest(university *model.University, request UniversityRequest) {
	university.Name = request.Name
	university.Logo = request.Logo
	university.Email = request.Email
	university.Site = request.Site
	university.Description = request.Description
	university.RegionID = request.RegionID
}
