package service

import (
	"api/dto"
	"api/model"
	"api/repository"
)

type IBenefitService interface {
	NewBenefit(request *dto.BenefitRequest) error
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

func (b *BenefitService) DeleteBenefit(benefitId string) error {
	return b.benefitRepo.DeleteBenefit(benefitId)
}

func newBenefitModel(request *dto.BenefitRequest) *model.Benefit {
	modelBenefit := model.Benefit{
		ProgramID:   request.ProgramID,
		MinClass:    request.MinClass,
		MinLevel:    request.MinLevel,
		BVI:         request.BVI,
		ConfSubjRel: make([]model.ConfirmationSubjects, len(request.ConfirmSubjects)),
	}
	for i := range request.ConfirmSubjects {
		modelBenefit.ConfSubjRel[i] = model.ConfirmationSubjects{
			SubjectID: request.ConfirmSubjects[i].SubjectID,
			Score:     request.ConfirmSubjects[i].Score,
		}
	}
	if !request.BVI {
		modelBenefit.FullScoreSubjects = make([]model.Subject, len(request.FullScoreSubjects))
		for i := range request.FullScoreSubjects {
			modelBenefit.FullScoreSubjects[i] = model.Subject{
				SubjectID: request.FullScoreSubjects[i].SubjectID,
			}
		}
	}
	return &modelBenefit
}
