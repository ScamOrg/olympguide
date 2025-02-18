package service

import (
	"api/dto"
	"api/model"
	"api/repository"
	"api/utils/errs"
	"context"
)

type IDiplomaService interface {
	NewDiploma(request *dto.DiplomaRequest) error
	NewDiplomaByUser(request *dto.DiplomaUserRequest, userID uint) error
	DeleteDiploma(diplomaID string, userID uint) error
	GetUserDiplomas(userID uint) ([]dto.DiplomaResponse, error)
	SyncUserDiplomas(userID uint) error
}

type DiplomaService struct {
	diplomaRepo repository.IDiplomaRepo
	userRepo    repository.IUserRepo
	olympRepo   repository.IOlympRepo
}

func NewDiplomaService(diplomaRepo repository.IDiplomaRepo, userRepo repository.IUserRepo, olympRepo repository.IOlympRepo) *DiplomaService {
	return &DiplomaService{diplomaRepo: diplomaRepo, userRepo: userRepo, olympRepo: olympRepo}
}

func (d *DiplomaService) NewDiplomaByUser(request *dto.DiplomaUserRequest, userID uint) error {
	diplomaRequest := dto.DiplomaRequest{
		UserID:             userID,
		DiplomaUserRequest: *request,
	}
	return d.NewDiploma(&diplomaRequest)
}

func (d *DiplomaService) NewDiploma(request *dto.DiplomaRequest) error {
	return d.diplomaRepo.NewDiploma(newDiplomaModel(request))
}

func (d *DiplomaService) DeleteDiploma(diplomaID string, userID uint) error {
	diploma, err := d.diplomaRepo.GetDiplomaByID(diplomaID)
	if err != nil {
		return err
	}
	if diploma.UserID != userID {
		return errs.NotEnoughRights
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

func (d *DiplomaService) SyncUserDiplomas(userID uint) error {
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
				Level:   diplomas[i].Olympiad.Level,
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
