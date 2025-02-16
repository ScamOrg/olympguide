package service

import (
	"api/dto"
	"api/model"
	"api/repository"
	"api/utils/constants"
	"api/utils/errs"
	"context"
	"fmt"
	"golang.org/x/crypto/bcrypt"
	"math/rand"
	"time"
)

type IAuthService interface {
	SendCode(email string) error
	VerifyCode(email, code string) error
	SignUp(request *dto.SignUpRequest) error
	Login(email string, password string) (uint, error)
}

type AuthService struct {
	codeRepo   repository.ICodeRepo
	userRepo   repository.IUserRepo
	regionRepo repository.IRegionRepo
}

func NewAuthService(codeRepo repository.ICodeRepo, userRepo repository.IUserRepo, regionRepo repository.IRegionRepo) *AuthService {
	return &AuthService{codeRepo: codeRepo, userRepo: userRepo, regionRepo: regionRepo}
}

func (s *AuthService) SendCode(email string) error {
	exists, err := s.codeRepo.CodeExists(context.Background(), email)
	if err != nil {
		return err
	}

	if exists {
		ttl, err := s.codeRepo.GetCodeTTL(context.Background(), email)
		if err != nil {
			return err
		}
		details := map[string]interface{}{"ttl": ttl.Seconds()}
		return errs.PreviousCodeNotExpired.WithAdditional(details)
	}

	code := generateCode()

	if err := s.codeRepo.SetCode(context.Background(), email, code, constants.MaxVerifyCodeAttempts, constants.EmailCodeTtl); err != nil {
		return err
	}
	if err := s.codeRepo.PublishEmailCode(context.Background(), email, code); err != nil {
		return err
	}
	return nil
}

func (s *AuthService) VerifyCode(email, requestCode string) error {
	storedCode, attempts, err := s.codeRepo.GetCodeInfo(context.Background(), email)
	if err != nil {
		return err
	} else if attempts == -1 {
		return errs.CodeNotFoundOrExpired
	}

	if attempts == 0 {
		return errs.TooManyAttempts
	}

	if storedCode != requestCode {
		if err = s.codeRepo.DecreaseCodeAttempt(context.Background(), email); err != nil {
			return err
		}
		return errs.InvalidCode
	}

	if err = s.codeRepo.DeleteCode(context.Background(), email); err != nil {
		return err
	}
	return nil
}

func (s *AuthService) SignUp(request *dto.SignUpRequest) error {
	parsedBirthday, err := time.Parse("02.01.2006", request.Birthday)
	if err != nil {
		return errs.InvalidBirthday
	}

	if !s.regionRepo.RegionExists(request.RegionID) {
		return errs.RegionNotFound
	}

	hashedPassword, err := hashPassword(request.Password)
	if err != nil {
		return err
	}

	user := newUserModel(request, hashedPassword, parsedBirthday)
	_, err = s.userRepo.CreateUser(user)
	if err != nil {
		return err
	}
	return nil
}

func (s *AuthService) Login(email, password string) (uint, error) {
	user, err := s.userRepo.GetUserByEmail(email)
	if err != nil {
		return 0, errs.UserNotFound
	}

	if err = bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(password)); err != nil {
		return 0, errs.InvalidPassword
	}

	return user.UserID, nil
}

func generateCode() string {
	code := fmt.Sprintf("%04d", rand.Intn(10000))
	return code
}

func hashPassword(password string) (string, error) {
	hashedBytes, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return "", err
	}
	return string(hashedBytes), nil
}

func newUserModel(request *dto.SignUpRequest, pwdHash string, parseBirthday time.Time) *model.User {
	return &model.User{
		FirstName:    request.FirstName,
		LastName:     request.LastName,
		SecondName:   request.SecondName,
		Email:        request.Email,
		RegionID:     request.RegionID,
		Birthday:     parseBirthday,
		PasswordHash: pwdHash,
	}
}
