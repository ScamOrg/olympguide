package handler

import (
	"api/dto"
	"api/service"
	"api/utils/constants"
	"api/utils/errs"
	"github.com/gin-gonic/gin"
	"net/http"
)

type DiplomaHandler struct {
	diplomaService service.IDiplomaService
}

func NewDiplomaHandler(diplomaService service.IDiplomaService) *DiplomaHandler {
	return &DiplomaHandler{diplomaService: diplomaService}
}

func (d *DiplomaHandler) GetUserDiplomas(c *gin.Context) {
	userID, _ := c.MustGet(constants.ContextUserID).(uint)

	diplomas, err := d.diplomaService.GetUserDiplomas(userID)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, diplomas)
}

func (d *DiplomaHandler) DeleteDiploma(c *gin.Context) {
	userID, _ := c.MustGet(constants.ContextUserID).(uint)
	diplomaID := c.Param("id")

	err := d.diplomaService.DeleteDiploma(diplomaID, userID)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.Status(http.StatusOK)
}

func (d *DiplomaHandler) SyncUserDiplomas(c *gin.Context) {
	userID, _ := c.MustGet(constants.ContextUserID).(uint)

	err := d.diplomaService.SyncUserDiplomas(userID)
	if err != nil {
		errs.HandleError(c, err)
	}

	c.Status(http.StatusOK)
}

func (d *DiplomaHandler) NewDiplomaByUser(c *gin.Context) {
	userID, _ := c.MustGet(constants.ContextUserID).(uint)
	var request dto.DiplomaUserRequest
	if err := c.ShouldBind(&request); err != nil {
		errs.HandleError(c, errs.InvalidRequest)
		return
	}

	err := d.diplomaService.NewDiplomaByUser(&request, userID)

	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.Status(http.StatusCreated)
}

func (d *DiplomaHandler) NewDiplomaByService(c *gin.Context) {
	var request dto.DiplomaRequest
	if err := c.ShouldBind(&request); err != nil {
		errs.HandleError(c, errs.InvalidRequest)
		return
	}

	err := d.diplomaService.NewDiploma(&request)

	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.Status(http.StatusCreated)
}
