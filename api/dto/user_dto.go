package dto

import "time"

type UserDataResponse struct {
	Email      string         `json:"email"`
	FirstName  string         `json:"first_name"`
	LastName   string         `json:"last_name"`
	SecondName string         `json:"second_name"`
	Birthday   time.Time      `json:"birthday"`
	Region     RegionResponse `json:"region"`
}
