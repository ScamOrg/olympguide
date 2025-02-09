package dto

type UserDataResponse struct {
	Email      string         `json:"email"`
	FirstName  string         `json:"first_name"`
	LastName   string         `json:"last_name"`
	SecondName string         `json:"second_name"`
	Birthday   string         `json:"birthday"`
	Region     RegionResponse `json:"region"`
}
