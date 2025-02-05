package middleware

//func UniversityMiddleware() gin.HandlerFunc {
//	return func(c *gin.Context) {
//		userID, _ := c.Get("user_id")
//		var adminUser model.AdminUser
//		if err := utils.DB.Where("user_id = ?", userID).First(&adminUser).Error; err != nil {
//			err.HandleAppError(c, err.UserNotAdmin)
//			c.Abort()
//			return
//		}
//		universityID := c.Param("id")
//		canEditUniversity := universityID == fmt.Sprint(adminUser.EditUniversityID)
//
//		if !adminUser.IsAdmin && !adminUser.IsFounder && !canEditUniversity {
//			errs.handleAppError(c, errs.NotEnoughRights)
//			c.Abort()
//			return
//		}
//		c.Next()
//	}
//}
