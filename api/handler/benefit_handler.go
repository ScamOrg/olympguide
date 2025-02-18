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
