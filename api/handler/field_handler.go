package handler

import (
	"api/dto"
	"api/service"
	"api/utils/errs"
	"github.com/gin-gonic/gin"
	"net/http"
)

type FieldHandler struct {
	fieldService service.IFieldService
}

func NewFieldHandler(fieldService service.IFieldService) *FieldHandler {
	return &FieldHandler{fieldService: fieldService}
}

func (h *FieldHandler) GetField(c *gin.Context) {
	fieldID := c.Param("id")

	field, err := h.fieldService.GetField(fieldID)

	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, field)
}

func (h *FieldHandler) GetGroups(c *gin.Context) {
	var queryParams dto.GroupQueryParams
	if err := c.ShouldBindQuery(&queryParams); err != nil {
		errs.HandleError(c, errs.InvalidRequest)
		return
	}

	groups, err := h.fieldService.GetGroups(queryParams)

	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, groups)
}
