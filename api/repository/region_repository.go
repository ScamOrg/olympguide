package repository

import (
	"api/model"
	"gorm.io/gorm"
)

type IRegionRepo interface {
	RegionExists(regionID uint) bool
	GetUserRegion(userID uint) (*model.Region, error)
	GetRegions() ([]model.Region, error)
	GetUniversityRegions() ([]model.Region, error)
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

func (r *PgRegionRepo) GetUserRegion(userID uint) (*model.Region, error) {
	var user model.User
	err := r.db.Preload("Region").First(&user, userID).Error
	if err != nil {
		return nil, err
	}
	return &user.Region, nil
}

func (r *PgRegionRepo) GetRegions() ([]model.Region, error) {
	var regions []model.Region
	if err := r.db.Find(&regions).Error; err != nil {
		return nil, err
	}
	return regions, nil
}

func (r *PgRegionRepo) GetUniversityRegions() ([]model.Region, error) {
	var regions []model.Region
	err := r.db.Model(&model.University{}).
		Select("DISTINCT olympguide.region.*").
		Joins("JOIN olympguide.region AS r ON olympguide.university.region_id = r.region_id").
		Find(&regions).Error

	if err != nil {
		return nil, err
	}
	return regions, nil
}
