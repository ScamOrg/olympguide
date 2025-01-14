package routers

import (
	"api/config"
	"api/controllers/olympiads"
	"api/controllers/users"
	"api/db"
	"api/middleware"
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
)

func SetupRouter(cfg *config.Config) *gin.Engine {
	r := gin.Default()

	store := db.GetSessionStore(cfg)
	r.Use(sessions.Sessions("session", store))

	r.GET("/olympiads", olympiads.GetOlympiads)
	r.GET("/fields", olympiads.GetFields)
	r.GET("/field/:id", olympiads.GetFieldByID)

	r.POST("/send_code", users.SendCode)
	r.POST("/verify_code", users.VerifyCode)
	r.POST("/sign_up", users.SignUp)
	r.POST("/login", users.Login)
	r.POST("/logout", users.Logout)

	userRoutes := r.Group("/user", middleware.SessionMiddleware())
	{
		userRoutes.GET("/region", users.GetRegion)
	}

	return r
}
