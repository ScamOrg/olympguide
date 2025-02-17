package service

import (
	"api/dto"
	"api/model"
	"api/repository"
)

type IBenefitService interface {
	NewBenefit(request dto.BenefitRequest) error
}

type BenefitService struct {
	benefitRepo repository.IBenefitRepo
}

func NewBenefitService(benefitRepo repository.IBenefitRepo) *BenefitService {
	return &BenefitService{benefitRepo: benefitRepo}
}

func (b *BenefitService) NewBenefit(request *dto.BenefitRequest) error {
	benefitModel := newBenefitModel(request)
	return b.benefitRepo.NewBenefit(benefitModel)
}

func newBenefitModel(request *dto.BenefitRequest) *model.Benefit {
	var benefitModel model.Benefit

}
