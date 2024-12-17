package routes

import (
	"api/controllers"
	"github.com/gin-gonic/gin"
)

func SetupRouter() *gin.Engine {
	r := gin.Default()

	r.GET("/olympiads", controllers.GetOlympiads)
	return r
}
