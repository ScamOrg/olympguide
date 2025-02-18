package dto

type UniversityRequest struct {
	Name        string `json:"name" binding:"required"`
	ShortName   string `json:"short_name" binding:"required"`
	Logo        string `json:"logo"`
	Email       string `json:"email"`
	Site        string `json:"site"`
	Description string `json:"description"`
	RegionID    uint   `json:"region_id" binding:"required"`
}

type UniversityShortResponse struct {
	UniversityID uint   `json:"university_id"`
	Name         string `json:"name"`
	ShortName    string `json:"short_name"`
	Logo         string `json:"logo"`
	Region       string `json:"region"`
	Like         bool   `json:"like"`
}

type UniversityQueryParams struct {
	RegionIDs    []string `form:"region_id"`
	FromMyRegion bool     `form:"from_my_region"`
	Search       string   `form:"search"`
	UserID       any
}

type UniversityResponse struct {
	Email       string `json:"email"`
	Site        string `json:"site"`
	Description string `json:"description"`
	UniversityShortResponse
}

type UniversityForProgramInfo struct {
	UniversityID uint   `json:"university_id"`
	Name         string `json:"name"`
	Logo         string `json:"logo"`
}
