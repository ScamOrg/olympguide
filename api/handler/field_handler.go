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

// GetGroups обрабатывает запрос на получение списка групп направлений и их направлений.
//
// @Summary Получение списка групп направлений подготовки
// @Description Возвращает список групп направлений и их направлений с возможностью фильтрации по уровню образования и поиску.
// @Tags Groups
// @Accept json
// @Produce json
// @Param degree query []string false "Уровень образования"
// @Param search query string false "Поиск по названию или коду (например, 'Математика' или '01.03.04')"
// @Success 200 {array} dto.GroupResponse "Список групп и их направлений"
// @Failure 400 {object} errs.AppError "Некорректные параметры запроса"
// @Failure 500 {object} errs.AppError "Внутренняя ошибка сервера"
// @Router /groups [get]
func (h *FieldHandler) GetGroups(c *gin.Context) {
	var queryParams dto.GroupQueryParams
	if err := c.ShouldBindQuery(&queryParams); err != nil {
		errs.HandleError(c, errs.InvalidRequest)
		return
	}

	groups, err := h.fieldService.GetGroups(&queryParams)

	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, groups)
}
