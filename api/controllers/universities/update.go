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

func UpdateUniversity(c *gin.Context) {
	universityID := c.Param("id")

	request, err := api.BindUniversityRequest(c)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": constants.InvalidRequest})
		return
	}

	university, err := logic.GetUniversityByID(universityID)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": constants.DataNotFound})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		}
		return
	}

	api.UpdateUniversityFromRequest(university, request)

	if err := logic.UpdateUniversity(university); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		return
	}

	c.Status(http.StatusOK)
}
