package api

import (
	"api/logic"
	"api/models"
	"fmt"
	"github.com/gin-gonic/gin"
)

type UniversityShortResponse struct {
	UniversityID uint   `json:"university_id"`
	Name         string `json:"name"`
	Logo         string `json:"logo"`
	Region       string `json:"region"`
	Like         bool   `json:"like"`
}

type UniversityResponse struct {
	Email       string `json:"email"`
	Site        string `json:"site"`
	Description string `json:"description"`
	UniversityShortResponse
}

func CreateUniversityResponse(c *gin.Context, university *models.University) UniversityResponse {
	like := logic.IsUserLikedUniversity(c, fmt.Sprintf("%d", university.UniversityID))

	return UniversityResponse{
		Email:       university.Email,
		Site:        university.Site,
		Description: university.Description,
		UniversityShortResponse: UniversityShortResponse{
			UniversityID: university.UniversityID,
			Name:         university.Name,
			Logo:         university.Logo,
			Region:       university.Region.Name,
			Like:         like,
		},
	}
}

func CreateUniversitiesResponse(c *gin.Context, universities []models.University) []UniversityShortResponse {
	var response []UniversityShortResponse

	for _, university := range universities {
		like := logic.IsUserLikedUniversity(c, fmt.Sprintf("%d", university.UniversityID))
		response = append(response, UniversityShortResponse{
			UniversityID: university.UniversityID,
			Name:         university.Name,
			Logo:         university.Logo,
			Region:       university.Region.Name,
			Like:         like,
		})
	}

	return response
}
