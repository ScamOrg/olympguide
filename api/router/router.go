package router

import (
	"api/handler"
	"api/middleware"
	"github.com/gin-gonic/gin"
)

func SetupRoutes(r *gin.Engine, authHandler *handler.AuthHandler, univerHandler *handler.UniverHandler) *gin.Engine {
	r.Use(middleware.SessionMiddleware())
	r.Use(middleware.ValidateID())

	setupAuthRoutes(r, authHandler)
	setupUniversityRoutes(r, univerHandler)
	setupUserRoutes(r, univerHandler)

	//setupOlympiadRoutes(r)
	//setupFieldRoutes(r)

	//setupRegionRoutes(r)

	return r
}

func setupAuthRoutes(r *gin.Engine, authHandler *handler.AuthHandler) {
	authGroup := r.Group("/auth")
	authGroup.POST("/send_code", authHandler.SendCode)
	authGroup.POST("/verify_code", authHandler.VerifyCode)
	authGroup.POST("/sign_up", authHandler.SignUp)
	authGroup.POST("/login", authHandler.Login)
	authGroup.POST("/logout", authHandler.Logout)
}

func setupUniversityRoutes(r *gin.Engine, univerHandler *handler.UniverHandler) {
	r.GET("/universities", univerHandler.GetUnivers)
	universityGroup := r.Group("/university")
	{
		universityGroup.GET("/:id", univerHandler.GetUniver)
		universitySecurityGroup := universityGroup.Group("/")
		// подключить проверку ролей
		universitySecurityGroup.Use(middleware.AuthMiddleware())
		{
			universitySecurityGroup.POST("/", univerHandler.NewUniver)
			universitySecurityGroup.PUT("/:id", univerHandler.UpdateUniver)
			universitySecurityGroup.DELETE("/:id", univerHandler.DeleteUniver)
		}
	}
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

func setupUserRoutes(r *gin.Engine, univerHandler *handler.UniverHandler) {
	userGroup := r.Group("/user", middleware.AuthMiddleware())
	{
		//userGroup.GET("/region", user.GetRegion)
		favouriteGroup := userGroup.Group("/favourite")
		{
			favouriteGroup.GET("/universities", univerHandler.GetLikedUnivers)
			favouriteGroup.POST("/university/:id", univerHandler.LikeUniver)
			favouriteGroup.DELETE("/university/:id", univerHandler.DislikeUniver)
			//favouriteGroup.GET("/olympiad", olympiad.GetLikedOlympiads)
			//favouriteGroup.POST("/olympiad/:id", user.LikeOlympiad)
			//favouriteGroup.DELETE("/olympiad/:id", user.UnlikeOlympiad)
			//
			//favouriteGroup.GET("/field", field.GetLikedFields)
			//favouriteGroup.POST("/field/:id", user.LikeField)
			//favouriteGroup.DELETE("/field/:id", user.UnlikeField)
		}
	}
}
