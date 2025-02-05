package api

import (
	"api/logic"
	"api/model"
)

type OlympiadShortResponse struct {
	OlympiadID uint   `json:"olympiad_id"`
	Name       string `json:"name"`
	Level      int16  `json:"level"`
	Profile    string `json:"profile"`
	Like       bool   `json:"like"`
}

type OlympiadResponse struct {
	OlympiadShortResponse
	Description string `json:"description"`
	Link        string `json:"link"`
}

func CreateOlympiadsResponse(olympiads []model.Olympiad, userID any) []OlympiadShortResponse {
	var response []OlympiadShortResponse
	for _, olympiad := range olympiads {
		like := logic.IsUserLikedOlympiad(userID, olympiad.OlympiadID)
		response = append(response, OlympiadShortResponse{
			OlympiadID: olympiad.OlympiadID,
			Name:       olympiad.Name,
			Level:      olympiad.Level,
			Profile:    olympiad.Profile,
			Like:       like,
		})
	}
	return response
}

func CreateLikedOlympiadsResponse(olympiads []model.Olympiad) []OlympiadShortResponse {
	var response []OlympiadShortResponse
	for _, olympiad := range olympiads {
		response = append(response, OlympiadShortResponse{
			OlympiadID: olympiad.OlympiadID,
			Name:       olympiad.Name,
			Level:      olympiad.Level,
			Profile:    olympiad.Profile,
			Like:       true,
		})
	}
	return response
}
