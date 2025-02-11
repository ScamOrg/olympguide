package dto

type FacultyNewRequest struct {
	FacultyUpdateRequest
	UniversityID uint `json:"university_id" binding:"required"`
}

type FacultyUpdateRequest struct {
	Name        string `json:"name" binding:"required"`
	Description string `json:"description"`
}

type FacultyShortResponse struct {
	FacultyID uint   `json:"faculty_id"`
	Name      string `json:"name"`
}
