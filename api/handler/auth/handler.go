package auth

import (
	"api/service"
)

type Handler struct {
	codeService service.ICodeService
	userService service.IUserService
}

func NewHandler(userService service.IUserService, codeService service.ICodeService) *Handler {
	return &Handler{codeService: codeService, userService: userService}
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

//func SignUp(c *gin.Context) {
//	var request transfer.SignUpRequest
//	if errs := c.ShouldBind(&request); errs != nil {
//		errs.HandleAppError(c, errs.InvalidRequest)
//		return
//	}
//	parsedBirthday, errs := time.Parse("02.01.2006", request.Birthday)
//	if errs != nil {
//		errs.HandleAppError(c, errs.InvalidBirthday)
//		return
//	}
//
//	regionExists := logic.IsRegionExists(request.RegionID)
//	if !regionExists {
//		errs.HandleAppError(c, errs.RegionNotFound)
//		return
//	}
//
//	hashedPassword, errs := hashPassword(request.Password)
//	if errs != nil {
//		errs.HandleUnknownError(c, errs)
//		return
//	}
//	user := transfer.CreateUserFromRequest(request, parsedBirthday, hashedPassword)
//	_, errs = logic.CreateUser(&user)
//	if errs != nil {
//		errs.HandleUnknownError(c, errs)
//		return
//	}
//	c.JSON(http.StatusCreated, gin.H{"message": "Signed up"})
//}
//
//func Login(c *gin.Context) {
//	var request LoginRequest
//	if errs := c.ShouldBind(&request); errs != nil {
//		errs.HandleAppError(c, errs.InvalidRequest)
//		return
//	}
//
//	user, errs := logic.GetUserByEmail(request.Email)
//	if errs != nil {
//		errs.HandleAppError(c, errs.UserNotFound)
//		return
//	}
//
//	if errs := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(request.Password)); errs != nil {
//		errs.HandleAppError(c, errs.InvalidPassword)
//		return
//	}
//
//	session := sessions.Default(c)
//	session.Set("user_id", user.UserID)
//	if errs := session.Save(); errs != nil {
//		errs.HandleUnknownError(c, errs)
//		return
//	}
//	c.JSON(http.StatusOK, gin.H{"message": "Logged in", "user_id": user.UserID})
//}
//
//func Logout(c *gin.Context) {
//	session := sessions.Default(c)
//	session.Clear()
//	errs := session.Save()
//	if errs != nil {
//		errs.HandleUnknownError(c, errs)
//		return
//	}
//	c.JSON(http.StatusOK, gin.H{"message": "Logged out"})
//}
//
//func hashPassword(password string) (string, errs) {
//	hashedBytes, errs := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
//	if errs != nil {
//		return "", errs
//	}
//	return string(hashedBytes), nil
//}
