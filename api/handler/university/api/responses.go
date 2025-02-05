package api

import (
	"api/logic"
	"api/model"
)

func CreateUniversityResponse(university *model.University, userID any) UniversityResponse {
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

func CreateUniversitiesResponse(universities []model.University, userID any) []UniversityShortResponse {
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

func CreateLikedUniversitiesResponse(universities []model.University) []UniversityShortResponse {
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
