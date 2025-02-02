package olympiads

import (
	"api/controllers/handlers"
	"api/controllers/olympiads/api"
	"api/logic"
	"github.com/gin-gonic/gin"
	"net/http"
)

func (h) GetOlympiads(c *gin.Context) {
	levels := c.QueryArray("level")
	profiles := c.QueryArray("profile")
	name := c.Query("name")
	sortBy := c.Query("sort")
	order := c.Query("order")
	userID, _ := c.Get("user_id")

	olympiads, err := logic.GetOlympiads(levels, profiles, name, sortBy, order)

	if err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}

	response := api.CreateOlympiadsResponse(olympiads, userID)
	c.JSON(http.StatusOK, response)
}

func GetLikedOlympiads(c *gin.Context) {
	userID, _ := c.MustGet("user_id").(uint)

	olympiads, err := logic.GetLikedOlympiads(userID)
	if err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}

	response := api.CreateLikedOlympiadsResponse(olympiads)
	c.JSON(http.StatusOK, response)
}
