package dto

type RegionResponse struct {
	RegionID uint   `json:"region_id"`
	Name     string `json:"name"`
}

type SubjectResponse struct {
	SubjectID uint   `json:"subject_id"`
	Name      string `json:"name"`
}
