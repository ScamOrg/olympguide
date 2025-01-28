package universities

import (
	"api/controllers/handlers"
	"api/controllers/universities/api"
	"api/logic"
	"github.com/gin-gonic/gin"
	"net/http"
)

func GetUniversity(c *gin.Context) {
	universityID := c.Param("id")
	userID, _ := c.Get("user_id")

	university, err := logic.GetUniversityByID(universityID)
	if err != nil {
		handlers.HandleError(c, err)
		return
	}

	response := api.CreateUniversityResponse(university, userID)
	c.JSON(http.StatusOK, response)
}

func GetUniversities(c *gin.Context) {
	regionIDs := c.QueryArray("region_id")
	fromMyRegion := c.Query("from_my_region") == "true"
	search := c.Query("search")
	userID, _ := c.Get("user_id")

	universities, _ := logic.GetUniversities(userID, regionIDs, fromMyRegion, search)

	response := api.CreateUniversitiesResponse(universities, userID)
	c.JSON(http.StatusOK, response)
}

func GetLikedUniversities(c *gin.Context) {
	userID, _ := c.MustGet("user_id").(uint)

	universities, err := logic.GetLikedUniversities(userID)
	if err != nil {
		handlers.HandleError(c, err)
		return
	}

	response := api.CreateLikedUniversitiesResponse(universities)
	c.JSON(http.StatusOK, response)
}
