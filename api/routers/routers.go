package routes

import (
	"api/controllers"
	"github.com/gin-gonic/gin"
)

func SetupRouter() *gin.Engine {
	r := gin.Default()

	r.GET("/olympiads", controllers.GetOlympiads)
	r.GET("/fields", controllers.GetFields)
	r.GET("/field/:id", controllers.GetFieldByID)
	return r
}
