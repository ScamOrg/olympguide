package fields

import (
	"api/controllers/fields/api"
	"api/controllers/handlers"
	"api/logic"
	"github.com/gin-gonic/gin"
	"net/http"
)

func GetFields(c *gin.Context) {
	userID, _ := c.Get("user_id")
	degrees := c.QueryArray("degree")
	search := c.Query("search")

	groups, err := logic.GetFields(degrees, search)
	if err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}

	response := api.CreateGroupResponse(groups, userID)
	c.JSON(http.StatusOK, response)
}

func GetLikedFields(c *gin.Context) {
	userID, _ := c.MustGet("user_id").(uint)

	fields, err := logic.GetLikedFields(userID)
	if err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}

	response := api.CreateLikedGroupResponse(fields)
	c.JSON(http.StatusOK, response)
}
