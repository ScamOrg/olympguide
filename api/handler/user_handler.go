package handler

import (
	"api/service"
	"api/utils/constants"
	"api/utils/errs"
	"github.com/gin-gonic/gin"
	"net/http"
)

type UserHandler struct {
	userService service.IUserService
}

func NewUserHandler(userService service.IUserService) *UserHandler {
	return &UserHandler{userService: userService}
}

func (u *UserHandler) GetUserData(c *gin.Context) {
	userID, _ := c.MustGet(constants.ContextUserID).(uint)

	user, err := u.userService.GetUserData(userID)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, user)
}
