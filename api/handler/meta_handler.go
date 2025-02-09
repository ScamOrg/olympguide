package handler

import (
	"api/service"
	"api/utils/errs"
	"github.com/gin-gonic/gin"
	"net/http"
)

type MetaHandler struct {
	metaService *service.MetaService
}

func NewMetaHandler(metaService *service.MetaService) *MetaHandler {
	return &MetaHandler{metaService: metaService}
}

func (h *MetaHandler) GetRegions(c *gin.Context) {
	regions, err := h.metaService.GetRegions()
	if err != nil {
		errs.HandleError(c, err)
		return
	}
	c.JSON(http.StatusOK, regions)
}

func (h *MetaHandler) GetUniversityRegions(c *gin.Context) {
	regions, err := h.metaService.GetUniversityRegions()
	if err != nil {
		errs.HandleError(c, err)
		return
	}
	c.JSON(http.StatusOK, regions)
}

func (h *MetaHandler) GetOlympiadProfiles(c *gin.Context) {
	profiles, err := h.metaService.GetOlympiadProfiles()
	if err != nil {
		errs.HandleError(c, err)
		return
	}
	c.JSON(http.StatusOK, profiles)
}
