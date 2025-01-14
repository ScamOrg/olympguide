package routers

import (
	"api/controllers/olympiads"
	"api/controllers/users"
	"github.com/gin-gonic/gin"
)

func SetupRouter() *gin.Engine {
	r := gin.Default()

	r.GET("/olympiads", olympiads.GetOlympiads)
	r.GET("/fields", olympiads.GetFields)
	r.GET("/field/:id", olympiads.GetFieldByID)

	r.POST("/send_code", users.SendCode)
	r.POST("/verify_code", users.VerifyCode)
	r.POST("/sign_up", users.SignUp)
	r.POST("/login", users.Login)
	r.POST("/logout", users.Logout)
	return r
}
