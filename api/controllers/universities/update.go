package universities

import (
	"api/controllers/handlers"
	"api/controllers/universities/api"
	"api/logic"
	"github.com/gin-gonic/gin"
	"net/http"
)

func UpdateUniversity(c *gin.Context) {
	universityID := c.Param("id")

	request, err := api.BindUniversityRequest(c)
	if err != nil {
		handlers.HandleAppError(c, handlers.InvalidRequest)
		return
	}

	university, err := logic.GetUniversityByID(universityID)
	if err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}

	api.UpdateUniversityFromRequest(university, request)

	if err := logic.UpdateUniversity(university); err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}

	c.Status(http.StatusOK)
}
