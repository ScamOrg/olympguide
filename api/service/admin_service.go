package service

import (
	"api/repository"
	"api/utils/role"
)

type IAdminService interface {
	HasPermission(userID uint, allowedRoles []string, universityID uint) bool
}

type AdminService struct {
	adminRepo repository.IAdminRepo
}

func NewAdminService(adminRepo repository.IAdminRepo) *AdminService {
	return &AdminService{adminRepo: adminRepo}
}

func (s *AdminService) HasPermission(userID uint, allowedRoles []string, universityID uint) bool {
	admin, err := s.adminRepo.GetAdminUserByID(userID)
	if err != nil {
		return false
	}

	for _, allowedRole := range allowedRoles {
		switch allowedRole {
		case role.Founder:
			if admin.IsFounder {
				return true
			}
		case role.Admin:
			if admin.IsAdmin {
				return true
			}
		case role.UniverEditor:
			if admin.EditUniversityID == universityID && universityID != 0 {
				return true
			}
		}
	}
	return false
}
