package handler

import (
	"api/service"
	"api/utils/errs"
	"github.com/gin-gonic/gin"
	"net/http"
)

type UniverHandler struct {
	univerService service.IUniverService
}

func NewUniverHandler(univerService service.IUniverService) *UniverHandler {
	return &UniverHandler{univerService: univerService}
}

func (u *UniverHandler) GetUniver(c *gin.Context) {
	universityID := c.Param("id")
	userID, _ := c.Get("user_id")

	university, err := u.univerService.GetUniver(universityID, userID)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, university)
}
