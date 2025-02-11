package handler

import (
	"api/dto"
	"api/service"
	"api/utils/errs"
	"github.com/gin-gonic/gin"
	"net/http"
)

type FacultyHandler struct {
	facultyService service.IFacultyService
}

func NewFacultyHandler(facultyService service.IFacultyService) *FacultyHandler {
	return &FacultyHandler{facultyService: facultyService}
}

func (f *FacultyHandler) NewFaculty(c *gin.Context) {
	var request dto.FacultyNewRequest
	if err := c.ShouldBind(&request); err != nil {
		errs.HandleError(c, errs.InvalidRequest)
		return
	}

	id, err := f.facultyService.NewFaculty(&request)

	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusCreated, gin.H{"faculty_id": id})
}

func (f *FacultyHandler) UpdateFaculty(c *gin.Context) {
	facultyID := c.Param("id")
	var request dto.FacultyUpdateRequest
	if err := c.ShouldBind(&request); err != nil {
		errs.HandleError(c, errs.InvalidRequest)
		return
	}

	id, err := f.facultyService.UpdateFaculty(&request, facultyID)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, gin.H{"faculty_id": id})
}

func (f *FacultyHandler) DeleteFaculty(c *gin.Context) {
	facultyID := c.Param("id")

	err := f.facultyService.DeleteFaculty(facultyID)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.Status(http.StatusOK)
}

func (f *FacultyHandler) GetFaculties(c *gin.Context) {
	universityID := c.Param("id")

	faculties, err := f.facultyService.GetFaculties(universityID)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, faculties)
}
