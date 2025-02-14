package handler

import (
	"api/dto"
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

func (p *ProgramHandler) GetProgram(c *gin.Context) {
	programID := c.Param("id")
	userID, _ := c.Get(constants.ContextUserID)

	program, err := p.programService.GetProgram(programID, userID)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, program)
}

func (p *ProgramHandler) GetLikedPrograms(c *gin.Context) {
	userID, _ := c.MustGet(constants.ContextUserID).(uint)

	programs, err := p.programService.GetLikedPrograms(userID)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, programs)
}

func (p *ProgramHandler) NewProgram(c *gin.Context) {
	var request dto.ProgramRequest
	if err := c.ShouldBind(&request); err != nil {
		errs.HandleError(c, errs.InvalidRequest)
		return
	}

	id, err := p.programService.NewProgram(&request)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusCreated, gin.H{"program_id": id})
}

func (p *ProgramHandler) LikeProgram(c *gin.Context) {
	programID := c.Param("id")
	userID, _ := c.MustGet(constants.ContextUserID).(uint)

	liked, err := p.programService.LikeProgram(programID, userID)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	if liked {
		c.JSON(http.StatusOK, gin.H{"message": "Liked"})
	} else {
		c.JSON(http.StatusOK, gin.H{"message": "Already liked"})
	}
}

func (p *ProgramHandler) DislikeProgram(c *gin.Context) {
	programID := c.Param("id")
	userID, _ := c.MustGet(constants.ContextUserID).(uint)

	disliked, err := p.programService.DislikeProgram(programID, userID)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	if disliked {
		c.JSON(http.StatusOK, gin.H{"message": "Disliked"})
	} else {
		c.JSON(http.StatusOK, gin.H{"message": "Already disliked"})
	}
}
