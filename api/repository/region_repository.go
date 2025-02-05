package repository

import (
	"api/model"
	"gorm.io/gorm"
)

type IRegionRepo interface {
	RegionExists(regionID uint) bool
	GetUserRegionID(userID uint) (uint, error)
}

type PgRegionRepo struct {
	db *gorm.DB
}

func NewPgRegionRepo(db *gorm.DB) *PgRegionRepo {
	return &PgRegionRepo{db: db}
}

func (r *PgRegionRepo) RegionExists(regionID uint) bool {
	var regionExists bool
	r.db.Raw("SELECT EXISTS(SELECT 1 FROM olympguide.region WHERE region_id = ?)", regionID).Scan(&regionExists)
	return regionExists
}

func (r *PgRegionRepo) GetUserRegionID(userID uint) (uint, error) {
	var user model.User
	if err := r.db.Where("user_id = ?").First(&user).Error; err != nil {
		return 0, err
	}
	return user.RegionID, nil
}
