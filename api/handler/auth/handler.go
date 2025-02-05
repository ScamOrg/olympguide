package auth

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
