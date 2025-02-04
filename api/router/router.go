package router

import (
	"api/handler/auth"
	"api/middleware"
	"github.com/gin-gonic/gin"
)

func SetupRoutes(r *gin.Engine, authHandler *auth.Handler) *gin.Engine {
	r.Use(middleware.SessionMiddleware())
	r.Use(middleware.ValidateID())

	setupAuthRoutes(r, authHandler)
	//setupOlympiadRoutes(r)
	//setupFieldRoutes(r)
	//setupUniversityRoutes(r)
	//setupRegionRoutes(r)
	//setupUserRoutes(r)

	return r
}

func setupAuthRoutes(r *gin.Engine, authHandler *auth.Handler) {
	authGroup := r.Group("/auth")
	authGroup.POST("/send_code", auth.SendCode)
	authGroup.POST("/verify_code", auth.VerifyCode)
	//authGroup.POST("/sign_up", auth.SignUp)
	//authGroup.POST("/login", auth.Login)
	//authGroup.POST("/logout", auth.Logout)
}

//func setupOlympiadRoutes(r *gin.Engine) {
//	r.GET("/olympiad", olympiad.GetOlympiads)
//}
//
//func setupRegionRoutes(r *gin.Engine) {
//	r.GET("/region", region.GetRegions)
//}
//
//func setupFieldRoutes(r *gin.Engine) {
//	r.GET("/field", field.GetFields)
//	r.GET("/field/:id", field.GetFieldByID)
//}
//

//
//func setupUniversityRoutes(r *gin.Engine) {
//
//	r.GET("/university", university.GetUniversities)
//
//	universityGroup := r.Group("/university")
//	{
//		universityGroup.GET("/:id", university.GetUniversity)
//
//		universitySecurityGroup := universityGroup.Group("/")
//		universitySecurityGroup.Use(middleware.AuthMiddleware(), middleware.UniversityMiddleware())
//		{
//			universitySecurityGroup.POST("/", university.CreateUniversity)
//			universitySecurityGroup.PUT("/:id", university.UpdateUniversity)
//			universitySecurityGroup.DELETE("/:id", university.DeleteUniversity)
//		}
//	}
//}
//
//func setupUserRoutes(r *gin.Engine) {
//	userGroup := r.Group("/user", middleware.AuthMiddleware())
//	{
//		userGroup.GET("/region", user.GetRegion)
//		favouriteGroup := userGroup.Group("/favourite")
//		{
//			favouriteGroup.GET("/university", university.GetLikedUniversities)
//			favouriteGroup.POST("/university/:id", user.LikeUniversity)
//			favouriteGroup.DELETE("/university/:id", user.UnlikeUniversity)
//
//			favouriteGroup.GET("/olympiad", olympiad.GetLikedOlympiads)
//			favouriteGroup.POST("/olympiad/:id", user.LikeOlympiad)
//			favouriteGroup.DELETE("/olympiad/:id", user.UnlikeOlympiad)
//
//			favouriteGroup.GET("/field", field.GetLikedFields)
//			favouriteGroup.POST("/field/:id", user.LikeField)
//			favouriteGroup.DELETE("/field/:id", user.UnlikeField)
//		}
//	}
//}
