package universities

import (
	"api/controllers/handlers"
	"api/logic"
	"github.com/gin-gonic/gin"
	"net/http"
)

func DeleteUniversity(c *gin.Context) {
	universityID := c.Param("id")
	university, err := logic.GetUniversityByID(universityID)

	if err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}

	if err = logic.DeleteUniversity(university); err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}
	c.Status(http.StatusOK)
}
