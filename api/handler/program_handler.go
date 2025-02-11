package handler

import (
	"api/service"
	"api/utils/constants"
	"api/utils/errs"
	"github.com/gin-gonic/gin"
	"net/http"
)

type ProgramHandler struct {
	programService service.IProgramService
}

func NewProgramHandler(programService service.IProgramService) *ProgramHandler {
	return &ProgramHandler{programService: programService}
}

func (p *ProgramHandler) GetProgramsByFaculty(c *gin.Context) {
	facultyID := c.Param("id")
	userID, _ := c.Get(constants.ContextUserID)

	programs, err := p.programService.GetProgramsByFacultyID(facultyID, userID)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, programs)
}
