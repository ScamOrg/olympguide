package university

import (
	"api/handler/errors"
	"api/handler/university/api"
	"api/logic"
	"github.com/gin-gonic/gin"
	"net/http"
)

func CreateUniversity(c *gin.Context) {
	request, err := api.BindUniversityRequest(c)
	if err != nil {
		err.HandleAppError(c, err.InvalidRequest)
		return
	}

	if !logic.IsRegionExists(request.RegionID) {
		err.HandleAppError(c, err.RegionNotFound)
		return
	}

	university := api.CreateUniversityFromRequest(request)
	id, err := logic.CreateUniversity(&university)
	if err != nil {
		err.HandleUnknownError(c, err)
		return
	}

	c.JSON(http.StatusCreated, gin.H{"university_id": id})
}
