package dto

type FacultyRequest struct {
	Name         string `json:"name" binding:"required"`
	Description  string `json:"description"`
	UniversityID uint   `json:"university_id" binding:"required"`
}

type FacultyShortResponse struct {
	FacultyID uint   `json:"faculty_id"`
	Name      string `json:"name"`
}
