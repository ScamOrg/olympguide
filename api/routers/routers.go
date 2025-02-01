package routers

import (
	"api/config"
	"api/controllers/auth"
	"api/controllers/fields"
	"api/controllers/olympiads"
	"api/controllers/regions"
	"api/controllers/universities"
	"api/controllers/users"
	"api/middleware"
	"api/utils"
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
)

func SetupRouter(cfg *config.Config) *gin.Engine {
	r := gin.Default()

	store := utils.CreateSessionStore(cfg)
	r.Use(sessions.Sessions("session", store))
	r.Use(middleware.SessionMiddleware())
	r.Use(middleware.ValidateID())

	setupOlympiadRoutes(r)
	setupFieldRoutes(r)
	setupAuthRoutes(r)
	setupUniversityRoutes(r)
	setupRegionRoutes(r)
	setupUserRoutes(r)

	return r
}

func setupOlympiadRoutes(r *gin.Engine) {
	r.GET("/olympiads", olympiads.GetOlympiads)
}

func setupRegionRoutes(r *gin.Engine) {
	r.GET("/regions", regions.GetRegions)
}

func setupFieldRoutes(r *gin.Engine) {
	r.GET("/fields", fields.GetFields)
	r.GET("/field/:id", fields.GetFieldByID)
}

func setupAuthRoutes(r *gin.Engine) {
	authGroup := r.Group("/auth")
	{
		authGroup.POST("/send_code", auth.SendCode)
		authGroup.POST("/verify_code", auth.VerifyCode)
		authGroup.POST("/sign_up", auth.SignUp)
		authGroup.POST("/login", auth.Login)
		authGroup.POST("/logout", auth.Logout)
	}
}

func setupUniversityRoutes(r *gin.Engine) {
	r.GET("/universities", universities.GetUniversities)

	universityGroup := r.Group("/university")
	{
		universityGroup.GET("/:id", universities.GetUniversity)

		universitySecurityGroup := universityGroup.Group("/")
		universitySecurityGroup.Use(middleware.AuthMiddleware(), middleware.UniversityMiddleware())
		{
			universitySecurityGroup.POST("/", universities.CreateUniversity)
			universitySecurityGroup.PUT("/:id", universities.UpdateUniversity)
			universitySecurityGroup.DELETE("/:id", universities.DeleteUniversity)
		}
	}
}

func setupUserRoutes(r *gin.Engine) {
	userGroup := r.Group("/user", middleware.AuthMiddleware())
	{
		userGroup.GET("/region", users.GetRegion)
		favouriteGroup := userGroup.Group("/favourite")
		{
			favouriteGroup.GET("/universities", universities.GetLikedUniversities)
			favouriteGroup.POST("/university/:id", users.LikeUniversity)
			favouriteGroup.DELETE("/university/:id", users.UnlikeUniversity)

			favouriteGroup.GET("/olympiads", olympiads.GetLikedOlympiads)
			favouriteGroup.POST("/olympiad/:id", users.LikeOlympiad)
			favouriteGroup.DELETE("/olympiad/:id", users.UnlikeOlympiad)

			favouriteGroup.GET("/fields", fields.GetLikedFields)
			favouriteGroup.POST("/field/:id", users.LikeField)
			favouriteGroup.DELETE("/field/:id", users.UnlikeField)
		}
	}
}
