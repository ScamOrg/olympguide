package repository

import (
	"api/dto"
	"api/model"
	"gorm.io/gorm"
)

type IOlympRepo interface {
	GetOlymps(params *dto.OlympQueryParams) ([]model.Olympiad, error)
	GetOlymp(olympiadID string, userID any) (*model.Olympiad, error)
	GetLikedOlymps(userID uint) ([]model.Olympiad, error)
	LikeOlymp(olympiadID uint, userID uint) error
	DislikeOlymp(olympiadID uint, userID uint) error
	ChangeOlympPopularity(olymp *model.Olympiad, value int)
	GetOlympiadProfiles() ([]string, error)
	Exists(olympiadID uint) bool
}
type PgOlympRepo struct {
	db *gorm.DB
}

func NewPgOlympRepo(db *gorm.DB) *PgOlympRepo {
	return &PgOlympRepo{db: db}
}

func (r *PgOlympRepo) GetOlymps(params *dto.OlympQueryParams) ([]model.Olympiad, error) {
	var olympiads []model.Olympiad

	query := r.db.Debug().
		Joins("LEFT JOIN olympguide.liked_olympiads lo ON lo.olympiad_id = olympguide.olympiad.olympiad_id AND lo.user_id = ?", params.UserID).
		Select("olympguide.olympiad.*, CASE WHEN lo.user_id IS NOT NULL THEN TRUE ELSE FALSE END as like")
	query = applyFilters(query, params.Levels, params.Profiles, params.Search)
	query = applySorting(query, params.Sort, params.Order)

	if err := query.Find(&olympiads).Error; err != nil {
		return nil, err
	}

	return olympiads, nil
}

func (r *PgOlympRepo) GetOlymp(olympiadID string, userID any) (*model.Olympiad, error) {
	var olymp model.Olympiad
	err := r.db.Debug().
		Joins("LEFT JOIN olympguide.liked_olympiads lo ON lo.olympiad_id = olympguide.olympiad.olympiad_id AND lo.user_id = ?", userID).
		Select("olympguide.olympiad.*, CASE WHEN lo.user_id IS NOT NULL THEN TRUE ELSE FALSE END as like").
		Where("olympguide.olympiad.olympiad_id = ?", olympiadID).
		First(&olymp).Error
	if err != nil {
		return nil, err
	}
	return &olymp, nil
}

func (r *PgOlympRepo) GetLikedOlymps(userID uint) ([]model.Olympiad, error) {
	var olymps []model.Olympiad
	err := r.db.Debug().
		Joins("LEFT JOIN olympguide.liked_olympiads lo ON lo.olympiad_id = olympguide.olympiad.olympiad_id AND lo.user_id = ?", userID).
		Where("lo.user_id IS NOT NULL").
		Select("olympguide.olympiad.*, TRUE as like").
		Order("popularity DESC").
		Find(&olymps).Error

	if err != nil {
		return nil, err
	}
	return olymps, nil
}

func (r *PgOlympRepo) ChangeOlympPopularity(olymp *model.Olympiad, value int) {
	olymp.Popularity += value
	r.db.Save(olymp)
}

func (r *PgOlympRepo) LikeOlymp(olympiadID uint, userID uint) error {
	likedOlymp := model.LikedOlympiads{
		OlympiadID: olympiadID,
		UserID:     userID,
	}
	err := r.db.Create(&likedOlymp).Error
	return err
}

func (r *PgOlympRepo) DislikeOlymp(olympiadID uint, userID uint) error {
	likedOlymp := model.LikedOlympiads{
		OlympiadID: olympiadID,
		UserID:     userID,
	}
	err := r.db.Delete(&likedOlymp).Error
	return err
}

func (r *PgOlympRepo) GetOlympiadProfiles() ([]string, error) {
	var profiles []string
	err := r.db.Model(&model.Olympiad{}).
		Distinct().
		Order("profile ASC").
		Pluck("profile", &profiles).Error
	return profiles, err
}

func (r *PgOlympRepo) Exists(olympiadID uint) bool {
	var count int64
	r.db.Model(&model.Olympiad{}).Where("olympiad_id = ?", olympiadID).Count(&count)
	return count > 0
}

func applyFilters(query *gorm.DB, levels, profiles []string, search string) *gorm.DB {
	if len(levels) > 0 {
		query = query.Where("level IN (?)", levels)
	}
	if len(profiles) > 0 {
		query = query.Where("profile IN (?)", profiles)
	}
	if search != "" {
		query = query.Where("name ILIKE ?", "%"+search+"%")
	}
	return query
}

func applySorting(query *gorm.DB, sort, order string) *gorm.DB {
	allowedSortFields := map[string]bool{
		"level":   true,
		"profile": true,
		"name":    true,
	}

	if allowedSortFields[sort] {
		if order != "asc" && order != "desc" {
			order = "asc"
		}
		return query.Order(sort + " " + order)
	}

	return query.Order("popularity DESC")
}
