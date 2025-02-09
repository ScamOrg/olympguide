package dto

type SignUpRequest struct {
	Email      string `json:"email" binding:"required"`
	Password   string `json:"password" binding:"required"`
	FirstName  string `json:"first_name" binding:"required"`
	LastName   string `json:"last_name" binding:"required"`
	SecondName string `json:"second_name" binding:"omitempty,min=1"`
	Birthday   string `json:"birthday" binding:"required"`
	RegionID   uint   `json:"region_id" binding:"required"`
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type SendRequest struct {
	Email string `json:"email" binding:"required"`
}

type VerifyRequest struct {
	Email string `json:"email" binding:"required"`
	Code  string `json:"code" binding:"required"`
}
