package routers

import (
	"api/config"
	"api/controllers/auth"
	"api/controllers/fields"
	"api/controllers/olympiads"
	"api/controllers/universities"
	"api/controllers/users"
	"api/controllers/users/likes"
	"api/db"
	"api/middleware"
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
)

func SetupRouter(cfg *config.Config) *gin.Engine {
	r := gin.Default()

	store := db.GetSessionStore(cfg)
	r.Use(sessions.Sessions("session", store))
	r.Use(middleware.SessionMiddleware())

	setupOlympiadRoutes(r)
	setupFieldRoutes(r)
	setupAuthRoutes(r)
	setupUniversityRoutes(r)
	setupUserRoutes(r)

	return r
}

func setupOlympiadRoutes(r *gin.Engine) {
	r.GET("/olympiads", olympiads.GetOlympiads)
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
		universityGroup.GET("/:id", universities.GetUniversityByID)

		universitySecurityGroup := universityGroup.Group("/")
		universitySecurityGroup.Use(middleware.AuthMiddleware(), middleware.UniversityMiddleware())
		{
			universitySecurityGroup.POST("/", universities.CreateUniversity)
			universitySecurityGroup.PATCH("/:id", universities.UpdateUniversityByID)
			universitySecurityGroup.DELETE("/:id", universities.DeleteUniversityByID)
		}
	}
}

func setupUserRoutes(r *gin.Engine) {
	userGroup := r.Group("/user", middleware.AuthMiddleware())
	{
		userGroup.GET("/region", users.GetRegion)
		favouriteGroup := userGroup.Group("/favourite")
		{
			favouriteGroup.GET("/universities", likes.GetLikedUniversities)
			favouriteGroup.POST("/universities/:id", likes.LikeUniversity)
			favouriteGroup.DELETE("/universities/:id", likes.UnlikeUniversity)
		}
	}
}
