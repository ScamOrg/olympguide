package repository

import (
	"gorm.io/gorm"
)

type IRegionRepo interface {
	RegionExists(regionID uint) bool
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
