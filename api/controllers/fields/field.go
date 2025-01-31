package fields

import (
	"api/controllers/fields/api"
	"api/controllers/handlers"
	"api/logic"
	"github.com/gin-gonic/gin"
	"net/http"
)

func GetFieldByID(c *gin.Context) {
	fieldID := c.Param("id")
	userID, _ := c.Get("user_id")

	field, err := logic.GetFieldByID(fieldID)

	if err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}

	response := api.CreateFieldResponse(field, userID)
	c.JSON(http.StatusOK, response)
}
