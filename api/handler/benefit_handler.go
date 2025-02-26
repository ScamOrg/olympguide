package handler

import (
	"api/dto"
	"api/service"
	"api/utils/errs"
	"github.com/gin-gonic/gin"
	"net/http"
)

type BenefitHandler struct {
	benefitService service.IBenefitService
}

func NewBenefitHandler(benefitService service.IBenefitService) *BenefitHandler {
	return &BenefitHandler{benefitService: benefitService}
}

func (b *BenefitHandler) NewBenefit(c *gin.Context) {
	var request dto.BenefitRequest
	if err := c.ShouldBind(&request); err != nil {
		errs.HandleError(c, errs.InvalidRequest)
		return
	}

	err := b.benefitService.NewBenefit(&request)

	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.Status(http.StatusCreated)
}

func (b *BenefitHandler) DeleteBenefit(c *gin.Context) {
	benefitID := c.Param("id")

	err := b.benefitService.DeleteBenefit(benefitID)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.Status(http.StatusOK)
}

// GetBenefitsByProgram
// @Summary Получить льготы по программе
// @Description Возвращает список льгот по олимпиадам для указанной образовательной программы.
// @Description Поддерживаются фильтры по уровням олимпиады, профилям олимпиады, признаку BVI, минимальному уровню диплома,
// @Description минимальному классу, а также поиск и сортировка. Льготы сгруппированы по олимпиадам, сортировка внутри программы: сначала БВИ, сначала 1 степень.
// @Tags Льготы по программе
// @Accept json
// @Produce json
// @Param id path string true "Идентификатор программы"
// @Param level query []string false "Фильтр по уровням олимпиады (1, 2, 3)"
// @Param profile query []string false "Фильтр по профилям (Математика)"
// @Param is_bvi query []bool false "Фильтр по BVI"
// @Param min_diploma_level query []uint false "Фильтр по минимальному уровню диплома (1, 2, 3)"
// @Param min_class query []uint false "Фильтр по минимальному классу (9, 10, 11)"
// @Param search query string false "Поиск по названию олимпиады"
// @Param sort query string false "Поле сортировки (level - по уровню олимпиады, profile - по профилю олимпиады), по умолчанию по убыванию популярности олимпиады."
// @Param order query string false "Порядок сортировки (asc или desc)"
// @Success 200 {array} dto.OlympiadBenefitTree "Список льгот, сгруппированных по олимпиадам"
// @Failure 400 {object} errs.AppError "Неверный запрос"
// @Failure 500 {object} errs.AppError "Ошибка сервера"
// @Router /programs/{id}/benefits [get]
func (b *BenefitHandler) GetBenefitsByProgram(c *gin.Context) {
	var queryParams dto.BenefitByProgramQueryParams
	if err := c.ShouldBindQuery(&queryParams); err != nil {
		errs.HandleError(c, errs.InvalidRequest)
		return
	}
	programID := c.Param("id")

	response, err := b.benefitService.GetBenefitsByProgram(programID, &queryParams)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, response)
}

// GetBenefitsByOlympiad
// @Summary Получить льготы по олимпиаде
// @Description Возвращает список льгот по программам для указанной олимпиады.
// @Description Поддерживаются фильтры по направлениям, признаку BVI, минимальному уровню диплома, минимальному классу, а также поиск и сортировка.
// @Description льготы сгруппированы по программам, сортировка внутри программы: сначала БВИ, сначала 1 степень.
// @Tags Льготы по олимпиаде
// @Accept json
// @Produce json
// @Param id path string true "Идентификатор олимпиады"
// @Param field query []string false "Фильтр по кодам направлений (01.03.04)"
// @Param is_bvi query []bool false "Фильтр по BVI"
// @Param min_diploma_level query []uint false "Фильтр по минимальному уровню диплома (1, 2, 3)"
// @Param min_class query []uint false "Фильтр по минимальному классу (9, 10, 11)"
// @Param search query string false "Поиск по названию программы и названию университета"
// @Param sort query string false "Поле сортировки программ (field - по коду, university - по популярности университета), по умолчанию по убыванию популярности программы."
// @Param order query string false "Порядок сортировки (asc или desc)"
// @Success 200 {array} dto.ProgramBenefitTree "Список льгот, сгруппированных по программам"
// @Failure 400 {object} errs.AppError "Неверный запрос"
// @Failure 500 {object} errs.AppError "Ошибка сервера"
// @Router /olympiads/{id}/benefits [get]
func (b *BenefitHandler) GetBenefitsByOlympiad(c *gin.Context) {
	var queryParams dto.BenefitByOlympiadQueryParams
	if err := c.ShouldBindQuery(&queryParams); err != nil {
		errs.HandleError(c, errs.InvalidRequest)
		return
	}
	olympiadID := c.Param("id")

	response, err := b.benefitService.GetBenefitsByOlympiad(olympiadID, &queryParams)
	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.JSON(http.StatusOK, response)
}
