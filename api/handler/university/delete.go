package university

import (
	"api/handler/errors"
	"api/logic"
	"github.com/gin-gonic/gin"
	"net/http"
)

func DeleteUniversity(c *gin.Context) {
	universityID := c.Param("id")
	university, err := logic.GetUniversityByID(universityID)

	if err != nil {
		err.HandleUnknownError(c, err)
		return
	}

	if err = logic.DeleteUniversity(university); err != nil {
		err.HandleUnknownError(c, err)
		return
	}
	c.Status(http.StatusOK)
}
