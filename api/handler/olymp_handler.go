package handler

import (
	"api/dto"
	"api/service"
	"api/utils/errs"
	"github.com/gin-gonic/gin"
	"net/http"
)

type OlympHandler struct {
	olympService service.IOlympService
}

func NewOlympHandler(olympService service.IOlympService) *OlympHandler {
	return &OlympHandler{olympService: olympService}
}

func (o *OlympHandler) GetOlympiads(c *gin.Context) {
	var queryParams dto.OlympQueryParams
	if err := c.ShouldBindQuery(&queryParams); err != nil {
		errs.HandleError(c, errs.InvalidRequest)
		return
	}
	queryParams.UserID, _ = c.Get("user_id")

	olymps, err := o.olympService.GetOlymps(&queryParams)

	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, olymps)
}

func (o *OlympHandler) GetLikedOlympiads(c *gin.Context) {
	userID, _ := c.MustGet("user_id").(uint)

	olymps, err := o.olympService.GetLikedOlymps(userID)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, olymps)
}
