package service

import (
	"api/dto"
	"api/model"
	"api/repository"
)

type IBenefitService interface {
	NewBenefit(request *dto.BenefitRequest) error
	DeleteBenefit(benefitId string) error
	GetBenefitsByProgram(programID string, request *dto.BenefitByProgramQueryParams) ([]dto.OlympiadBenefitTree, error)
	GetBenefitsByOlympiad(olympiadID string, request *dto.BenefitByOlympiasQueryParams) ([]dto.ProgramBenefitTree, error)
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

func (b *BenefitService) GetBenefitsByProgram(programID string, request *dto.BenefitByProgramQueryParams) ([]dto.OlympiadBenefitTree, error) {
	benefits, err := b.benefitRepo.GetBenefitsByProgram(programID, request)
	if err != nil {
		return nil, err
	}
	return newOlympiadBenefitTrees(benefits), nil
}

func (b *BenefitService) GetBenefitsByOlympiad(olympiadID string, request *dto.BenefitByOlympiasQueryParams) ([]dto.ProgramBenefitTree, error) {
	benefits, err := b.benefitRepo.GetBenefitsByOlympiad(olympiadID, request)
	if err != nil {
		return nil, err
	}
	return newProgramBenefitTrees(benefits), nil
}

func newBenefitModel(request *dto.BenefitRequest) *model.Benefit {
	benefit := model.Benefit{
		ProgramID:       request.ProgramID,
		OlympiadID:      request.OlympiadID,
		MinClass:        request.MinClass,
		MinDiplomaLevel: request.MinDiplomaLevel,
		BVI:             request.BVI,
		ConfSubjRel:     make([]model.ConfirmationSubjects, len(request.ConfirmSubjects)),
	}

	for i := range request.ConfirmSubjects {
		benefit.ConfSubjRel[i] = model.ConfirmationSubjects{
			SubjectID: request.ConfirmSubjects[i].SubjectID,
			Score:     request.ConfirmSubjects[i].Score,
		}
	}

	if !request.BVI {
		benefit.FullScoreSubjects = make([]model.Subject, len(request.FullScoreSubjects))
		for i := range request.FullScoreSubjects {
			benefit.FullScoreSubjects[i] = model.Subject{
				SubjectID: request.FullScoreSubjects[i],
			}
		}
	}

	return &benefit
}

func newOlympiadBenefitTrees(benefits []model.Benefit) []dto.OlympiadBenefitTree {
	var result []dto.OlympiadBenefitTree
	var currentTree *dto.OlympiadBenefitTree
	var currentOlympiadID uint

	for _, b := range benefits {
		if b.OlympiadID != currentOlympiadID {
			currentOlympiadID = b.OlympiadID
			tree := dto.OlympiadBenefitTree{
				Olympiad: dto.OlympiadBenefitInfo{
					OlympiadID: b.Olympiad.OlympiadID,
					Name:       b.Olympiad.Name,
					Level:      b.Olympiad.Level,
					Profile:    b.Olympiad.Profile,
				},
			}
			result = append(result, tree)
			currentTree = &result[len(result)-1]
		}

		if currentTree == nil {
			continue
		}

		currentTree.Benefits = append(currentTree.Benefits, extractBenefitInfo(b))
	}
	return result
}

func newProgramBenefitTrees(benefits []model.Benefit) []dto.ProgramBenefitTree {
	var result []dto.ProgramBenefitTree
	var currentTree *dto.ProgramBenefitTree
	var currentProgramID uint

	for _, b := range benefits {
		if b.ProgramID != currentProgramID {
			currentProgramID = b.ProgramID
			tree := dto.ProgramBenefitTree{
				Program: dto.ProgramBenefitInfo{
					ProgramID:       b.Program.ProgramID,
					Name:            b.Program.Name,
					Field:           b.Program.Field.Code,
					UniverShortName: b.Program.University.ShortName,
				},
			}
			result = append(result, tree)
			currentTree = &result[len(result)-1]
		}

		if currentTree == nil {
			continue
		}

		currentTree.Benefits = append(currentTree.Benefits, extractBenefitInfo(b))
	}

	return result
}

func extractBenefitInfo(b model.Benefit) dto.BenefitInfo {
	benefitInfo := dto.BenefitInfo{
		MinClass:        b.MinClass,
		MinDiplomaLevel: b.MinDiplomaLevel,
		BVI:             b.BVI,
	}

	for i := range b.ConfirmationSubjects {
		if i < len(b.ConfSubjRel) {
			benefitInfo.ConfirmSubjects = append(benefitInfo.ConfirmSubjects, dto.ConfirmSubjectResp{
				Name:  b.ConfirmationSubjects[i].Name,
				Score: b.ConfSubjRel[i].Score,
			})
		}
	}

	for _, subj := range b.FullScoreSubjects {
		benefitInfo.FullScoreSubjects = append(benefitInfo.FullScoreSubjects, subj.Name)
	}

	return benefitInfo
}
