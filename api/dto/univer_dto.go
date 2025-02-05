package dto

type UniversityRequest struct {
	Name        string `json:"name" binding:"required"`
	Logo        string `json:"logo"`
	Email       string `json:"email"`
	Site        string `json:"site"`
	Description string `json:"description"`
	RegionID    uint   `json:"region_id" binding:"required"`
}

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
