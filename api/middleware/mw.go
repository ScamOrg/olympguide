package middleware

import "api/service"

type Mw struct {
	adminService service.IAdminService
}

func NewMw(adminService service.IAdminService) *Mw {
	return &Mw{adminService: adminService}
}
