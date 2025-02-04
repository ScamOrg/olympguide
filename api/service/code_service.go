package service

import (
	"api/constants"
	"api/errs"
	"api/repository"
	"context"
	"fmt"
	"math/rand"
)

type ICodeService interface {
	SendCode(email string) error
	VerifyCode(email, code string) error
}

type CodeService struct {
	repo repository.ICodeRepo
}

func NewCodeService(repo repository.ICodeRepo) *CodeService {
	return &CodeService{repo: repo}
}

func (s *CodeService) SendCode(email string) error {
	exists, err := s.repo.CodeExists(context.Background(), email)
	if err != nil {
		return err
	}

	if exists {
		time, err := s.repo.GetCodeTTL(context.Background(), email)
		if err != nil {
			return err
		}
		details := map[string]interface{}{"time": time.Seconds()}
		return errs.PreviousCodeNotExpired.WithAdditional(details)
	}

	code := generateCode()

	if err := s.repo.SetCode(context.Background(), email, code, constants.MaxVerifyCodeAttempts); err != nil {
		return err
	}
	if err := s.repo.SendCode(context.Background(), email, code); err != nil {
		return err
	}
	return nil
}

func (s *CodeService) VerifyCode(email, requestCode string) error {
	storedCode, attempts, err := s.repo.GetCodeInfo(context.Background(), email)
	if err != nil {
		return err
	} else if attempts == -1 {
		return errs.CodeNotFoundOrExpired
	}

	if attempts == 0 {
		return errs.TooManyAttempts
	}

	if storedCode != requestCode {
		if err = s.repo.DecreaseCodeAttempt(context.Background(), email); err != nil {
			return err
		}
		return errs.InvalidCode
	}

	if err = s.repo.DeleteCode(context.Background(), email); err != nil {
		return err
	}
	return nil
}

func generateCode() string {
	code := fmt.Sprintf("%04d", rand.Intn(10000))
	return code
}
