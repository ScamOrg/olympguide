package dto

type DiplomaRequest struct {
	UserID uint `json:"user_id"`
	DiplomaUserRequest
}

type DiplomaUserRequest struct {
	OlympiadID uint `json:"olympiad_id" binding:"required"`
	Class      uint `json:"class" binding:"required,min=9,max=11"`
	Level      uint `json:"level" binding:"required,min=1,max=3"`
}

type OlympDiplomaInfo struct {
	Name    string `json:"name"`
	Profile string `json:"profile"`
}

type DiplomaResponse struct {
	DiplomaID uint             `json:"diploma_id"`
	Class     uint             `json:"class"`
	Level     uint             `json:"level"`
	Olympiad  OlympDiplomaInfo `json:"olympiad"`
}

type UploadDiplomasMessage struct {
	UserID     uint   `json:"user_id"`
	FirstName  string `json:"first_name"`
	LastName   string `json:"last_name"`
	SecondName string `json:"second_name"`
	Birthday   string `json:"birthday"`
}
