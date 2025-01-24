package api

import (
	"api/logic"
	"api/models"
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

func CreateUniversityResponse(university *models.University, userID any) UniversityResponse {
	like := logic.IsUserLikedUniversity(userID, university.UniversityID)

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

func CreateUniversitiesResponse(universities []models.University, userID any) []UniversityShortResponse {
	var response []UniversityShortResponse

	for _, university := range universities {
		like := logic.IsUserLikedUniversity(userID, university.UniversityID)
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

func CreateLikedUniversitiesResponse(universities []models.University) []UniversityShortResponse {
	var response []UniversityShortResponse
	for _, university := range universities {
		response = append(response, UniversityShortResponse{
			UniversityID: university.UniversityID,
			Name:         university.Name,
			Logo:         university.Logo,
			Region:       university.Region.Name,
			Like:         true,
		})
	}
	return response
}
