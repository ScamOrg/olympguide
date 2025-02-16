package service

import (
	"api/dto"
	"api/model"
	"api/repository"
	"api/utils/errs"
	"context"
)

type IDiplomaService interface {
}

type DiplomaService struct {
	diplomaRepo repository.IDiplomaRepo
	userRepo    repository.IUserRepo
	olympRepo   repository.IOlympRepo
}

func NewDiplomaService(diplomaRepo repository.IDiplomaRepo) *DiplomaService {
	return &DiplomaService{diplomaRepo: diplomaRepo}
}

func (d *DiplomaService) NewDiploma(request *dto.DiplomaRequest) error {
	if !d.userRepo.Exists(request.UserID) {
		return errs.UserNotExist
	}
	if !d.olympRepo.Exists(request.OlympiadID) {
		return errs.OlympNotExist
	}

	return d.diplomaRepo.NewDiploma(newDiplomaModel(request))
}

func (d *DiplomaService) DeleteDiploma(diplomaID string) error {
	diploma, err := d.diplomaRepo.GetDiplomaByID(diplomaID)
	if err != nil {
		return err
	}
	return d.diplomaRepo.DeleteDiploma(diploma)
}

func (d *DiplomaService) GetUserDiplomas(userID uint) ([]dto.DiplomaResponse, error) {
	diplomas, err := d.diplomaRepo.GetDiplomasByUserID(userID)
	if err != nil {
		return nil, err
	}
	return newDiplomasResponse(diplomas), nil
}

func (d *DiplomaService) UploadUserDiplomas(userID uint) error {
	user, err := d.userRepo.GetUserByID(userID)
	if err != nil {
		return err
	}

	message := newUploadDiplomasMessage(user)
	if err = d.diplomaRepo.PublishUploadDiplomas(context.Background(), message); err != nil {
		return err
	}
	return nil
}

func newDiplomaModel(request *dto.DiplomaRequest) *model.Diploma {
	return &model.Diploma{
		UserID:     request.UserID,
		OlympiadID: request.OlympiadID,
		Class:      request.Class,
		Level:      request.Level,
	}
}

func newDiplomasResponse(diplomas []model.Diploma) []dto.DiplomaResponse {
	diplomasResponse := make([]dto.DiplomaResponse, len(diplomas))
	for i := range diplomas {
		diplomasResponse[i] = dto.DiplomaResponse{
			DiplomaID: diplomas[i].DiplomaID,
			Class:     diplomas[i].Class,
			Level:     diplomas[i].Level,
			Olympiad: dto.OlympDiplomaInfo{
				Name:    diplomas[i].Olympiad.Name,
				Profile: diplomas[i].Olympiad.Profile,
			},
		}
	}
	return diplomasResponse
}

func newUploadDiplomasMessage(user *model.User) *dto.UploadDiplomasMessage {
	return &dto.UploadDiplomasMessage{
		UserID:     user.UserID,
		FirstName:  user.FirstName,
		LastName:   user.LastName,
		SecondName: user.SecondName,
		Birthday:   user.Birthday.Format("02.01.2006"),
	}
}
