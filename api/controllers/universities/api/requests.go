package api

import (
	"api/models"
	"github.com/gin-gonic/gin"
)

type UniversityRequest struct {
	Name        string `json:"name" binding:"required"`
	Logo        string `json:"logo"`
	Email       string `json:"email"`
	Site        string `json:"site"`
	Description string `json:"description"`
	RegionID    uint   `json:"region_id" binding:"required"`
}

func BindUniversityRequest(c *gin.Context) (UniversityRequest, error) {
	var request UniversityRequest
	if err := c.ShouldBind(&request); err != nil {
		return UniversityRequest{}, err
	}
	return request, nil
}

func CreateUniversityFromRequest(request UniversityRequest) models.University {
	return models.University{
		Name:        request.Name,
		Logo:        request.Logo,
		Site:        request.Site,
		Email:       request.Email,
		Description: request.Description,
		RegionID:    request.RegionID,
	}
}

func UpdateUniversityFromRequest(university *models.University, request UniversityRequest) {
	university.Name = request.Name
	university.Logo = request.Logo
	university.Email = request.Email
	university.Site = request.Site
	university.Description = request.Description
	university.RegionID = request.RegionID
}
