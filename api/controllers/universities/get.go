package universities

import (
	"api/constants"
	"api/controllers/universities/api"
	"api/logic"
	"errors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"net/http"
)

func GetUniversity(c *gin.Context) {
	universityID := c.Param("id")
	university, err := logic.GetUniversityByID(universityID)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": constants.DataNotFound})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		}
		return
	}
	logic.IncrementUniversityPopularity(university)
	response := api.CreateUniversityResponse(c, university)
	c.JSON(http.StatusOK, response)
}

func GetUniversities(c *gin.Context) {
	universities, err := logic.GetUniversities(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		return
	}

	response := api.CreateUniversitiesResponse(c, universities)
	c.JSON(http.StatusOK, response)
}
