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

	err := b.benefitService.NewBenefit(request)

	if err != nil {
		errs.HandleError(c, err)
		return
	}

	c.Status(http.StatusCreated)
}
