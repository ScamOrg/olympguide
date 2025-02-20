package handler

import (
	"api/dto"
	"api/service"
	"api/utils/constants"
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

// GetOlympiads возвращает список олимпиад с возможностью фильтрации и сортировки.
//
// @Summary Получить список олимпиад
// @Description Возвращает список олимпиад с фильтрацией по уровню, профилю и поисковому запросу. Также поддерживается сортировка.
// @Tags olympiads
// @Accept json
// @Produce json
// @Param level query []string false "Фильтр по уровням (можно передавать несколько значений)" collectionFormat(multi)
// @Param profile query []string false "Фильтр по профилям (можно передавать несколько значений)" collectionFormat(multi)
// @Param search query string false "Поисковый запрос по названию олимпиады"
// @Param sort query string false "Поле для сортировки (level, profile, name). По умолчанию сортируется по убыванию популярности"
// @Param order query string false "Порядок сортировки (asc, desc). По умолчанию asc, если указан `sort`"
// @Success 200 {array} dto.OlympiadShortResponse "Список олимпиад"
// @Failure 400 {object} errs.AppError "Некорректные параметры запроса"
// @Failure 500 {object} errs.AppError "Внутренняя ошибка сервера"
// @Router /olympiads [get]
func (o *OlympHandler) GetOlympiads(c *gin.Context) {
	var queryParams dto.OlympQueryParams
	if err := c.ShouldBindQuery(&queryParams); err != nil {
		errs.HandleError(c, errs.InvalidRequest)
		return
	}
	queryParams.UserID, _ = c.Get(constants.ContextUserID)

	olymps, err := o.olympService.GetOlymps(&queryParams)

	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, olymps)
}

func (o *OlympHandler) GetLikedOlympiads(c *gin.Context) {
	userID, _ := c.MustGet(constants.ContextUserID).(uint)

	olymps, err := o.olympService.GetLikedOlymps(userID)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, olymps)
}

func (o *OlympHandler) GetOlympiad(c *gin.Context) {
	olympiadID := c.Param("id")
	userID, _ := c.Get(constants.ContextUserID)

	olympiad, err := o.olympService.GetOlymp(olympiadID, userID)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, olympiad)
}

func (o *OlympHandler) LikeOlymp(c *gin.Context) {
	olympID := c.Param("id")
	userID, _ := c.MustGet(constants.ContextUserID).(uint)

	liked, err := o.olympService.LikeOlymp(olympID, userID)
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

func (o *OlympHandler) DislikeOlymp(c *gin.Context) {
	olympID := c.Param("id")
	userID, _ := c.MustGet(constants.ContextUserID).(uint)

	disliked, err := o.olympService.DislikeOlymp(olympID, userID)
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
