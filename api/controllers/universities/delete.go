package universities

import (
	"api/constants"
	"api/logic"
	"errors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"net/http"
)

func DeleteUniversity(c *gin.Context) {
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

	if err := logic.DeleteUniversity(university); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		return
	}
	c.Status(http.StatusOK)
}
