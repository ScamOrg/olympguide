package handler

import (
	"api/dto"
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

func (u *UniverHandler) GetUnivers(c *gin.Context) {
	var queryParams dto.UniversityQueryParams
	if err := c.ShouldBindQuery(&queryParams); err != nil {
		errs.HandleError(c, errs.InvalidRequest)
		return
	}
	queryParams.UserID, _ = c.Get("user_id")

	univers, err := u.univerService.GetUnivers(&queryParams)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, univers)
}

func (u *UniverHandler) GetLikedUnivers(c *gin.Context) {
	userID, _ := c.MustGet("user_id").(uint)

	univers, err := u.univerService.GetLikedUnivers(userID)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, univers)
}

func (u *UniverHandler) NewUniver(c *gin.Context) {
	var request dto.UniversityRequest
	if err := c.ShouldBind(&request); err != nil {
		errs.HandleError(c, errs.InvalidRequest)
		return
	}

	id, err := u.univerService.NewUniver(&request)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusCreated, gin.H{"university_id": id})
}

func (u *UniverHandler) UpdateUniver(c *gin.Context) {
	universityID := c.Param("id")
	var request dto.UniversityRequest
	if err := c.ShouldBind(&request); err != nil {
		errs.HandleError(c, errs.InvalidRequest)
		return
	}

	id, err := u.univerService.UpdateUniver(&request, universityID)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, gin.H{"university_id": id})
}

func (u *UniverHandler) DeleteUniver(c *gin.Context) {
	universityID := c.Param("id")

	err := u.univerService.DeleteUniver(universityID)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.Status(http.StatusOK)
}

func (u *UniverHandler) LikeUniver(c *gin.Context) {
	universityID := c.Param("id")
	userID, _ := c.MustGet("user_id").(uint)

	liked, err := u.univerService.LikeUniver(universityID, userID)
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

func (u *UniverHandler) DislikeUniver(c *gin.Context) {
	universityID := c.Param("id")
	userID, _ := c.MustGet("user_id").(uint)

	disliked, err := u.univerService.DislikeUniver(universityID, userID)
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
