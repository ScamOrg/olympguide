package service

import "api/repository"

type CodeService struct {
	repo repository.EmailCodeRepository
}

func NewCodeService(repo repository.EmailCodeRepository) *CodeService {
	return &CodeService{repo: repo}
}
