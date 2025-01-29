package universities

import (
	"api/controllers/handlers"
	"api/controllers/universities/api"
	"api/logic"
	"github.com/gin-gonic/gin"
	"net/http"
)

func CreateUniversity(c *gin.Context) {
	request, err := api.BindUniversityRequest(c)
	if err != nil {
		handlers.HandleAppError(c, handlers.InvalidRequest)
		return
	}

	if !logic.IsRegionExists(request.RegionID) {
		handlers.HandleAppError(c, handlers.RegionNotFound)
		return
	}

	university := api.CreateUniversityFromRequest(request)
	id, err := logic.CreateUniversity(&university)
	if err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}

	c.JSON(http.StatusCreated, gin.H{"university_id": id})
}
