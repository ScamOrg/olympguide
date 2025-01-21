package universities

import (
	"api/constants"
	"api/controllers/universities/api"
	"api/logic"
	"github.com/gin-gonic/gin"
	"net/http"
)

func CreateUniversity(c *gin.Context) {
	request, err := api.BindUniversityRequest(c)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": constants.InvalidRequest})
		return
	}

	if !logic.IsRegionExists(request.RegionID) {
		c.JSON(http.StatusBadRequest, gin.H{"error": constants.RegionNotFound})
		return
	}

	university := api.CreateUniversityFromRequest(request)
	id, err := logic.CreateUniversity(&university)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"university_id": id})
}
