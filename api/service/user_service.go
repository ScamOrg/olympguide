package service

import "api/repository"

type IUserService interface {
	get(string, string) (string, error)
}

type UserService struct {
	repo repository.IUserRepo
}

func NewUserService(repo repository.IUserRepo) *UserService {
	return &UserService{repo: repo}
}
