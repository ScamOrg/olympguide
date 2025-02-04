package university

import (
	"api/handler/errors"
	"api/handler/university/api"
	"api/logic"
	"github.com/gin-gonic/gin"
	"net/http"
)

func GetUniversity(c *gin.Context) {
	universityID := c.Param("id")
	userID, _ := c.Get("user_id")

	university, err := logic.GetUniversityByID(universityID)
	if err != nil {
		err.HandleUnknownError(c, err)
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

	universities, err := logic.GetUniversities(userID, regionIDs, fromMyRegion, search)
	if err != nil {
		err.HandleUnknownError(c, err)
		return
	}

	response := api.CreateUniversitiesResponse(universities, userID)
	c.JSON(http.StatusOK, response)
}

func GetLikedUniversities(c *gin.Context) {
	userID, _ := c.MustGet("user_id").(uint)

	universities, err := logic.GetLikedUniversities(userID)
	if err != nil {
		err.HandleUnknownError(c, err)
		return
	}

	response := api.CreateLikedUniversitiesResponse(universities)
	c.JSON(http.StatusOK, response)
}
