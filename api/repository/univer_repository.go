package repository

import (
	"api/model"
	"gorm.io/gorm"
)

type IUniverRepo interface {
	GetUniver(universityID string, userID any) (*model.University, error)
	GetUnivers(search string, regionIDs []string, userID any) ([]model.University, error)
	GetLikedUnivers(userID uint) ([]model.University, error)
	NewUniver(univer *model.University) (uint, error)
	UpdateUniver(univer *model.University) error
	DeleteUniver(univer *model.University) error
	ChangeUniverPopularity(university *model.University, value int)
	LikeUniver(universityID uint, userID uint) error
	DislikeUniver(universityID uint, userID uint) error
}

type PgUniverRepo struct {
	db *gorm.DB
}

func NewPgUniverRepo(db *gorm.DB) *PgUniverRepo {
	return &PgUniverRepo{db: db}
}

func (u *PgUniverRepo) GetUniver(universityID string, userID any) (*model.University, error) {
	var university model.University
	err := u.db.Debug().Preload("Region").
		Joins("LEFT JOIN olympguide.liked_universities lu ON lu.university_id = olympguide.university.university_id AND lu.user_id = ?", userID).
		Select("olympguide.university.*, CASE WHEN lu.user_id IS NOT NULL THEN TRUE ELSE FALSE END as like").
		Where("olympguide.university.university_id = ?", universityID).
		First(&university).Error
	if err != nil {
		return nil, err
	}
	return &university, nil
}

func (u *PgUniverRepo) GetUnivers(search string, regionIDs []string, userID any) ([]model.University, error) {
	var universities []model.University
	query := u.db.Debug().Preload("Region").
		Joins("LEFT JOIN olympguide.liked_universities lu ON lu.university_id = olympguide.university.university_id AND lu.user_id = ?", userID).
		Select("olympguide.university.*, CASE WHEN lu.user_id IS NOT NULL THEN TRUE ELSE FALSE END as like")
	if search != "" {
		query = query.Where("name ILIKE ?", "%"+search+"%")
	}
	if len(regionIDs) > 0 {
		query = query.Where("region_id IN (?)", regionIDs)
	}
	if err := query.Order("popularity DESC").Find(&universities).Error; err != nil {
		return nil, err
	}
	return universities, nil
}

func (u *PgUniverRepo) GetLikedUnivers(userID uint) ([]model.University, error) {
	var universities []model.University
	err := u.db.Debug().
		Joins("LEFT JOIN olympguide.liked_universities lu ON lu.university_id = olympguide.university.university_id AND lu.user_id = ?", userID).
		Where("lu.user_id IS NOT NULL").
		Select("olympguide.university.*, TRUE as like").
		Order("popularity DESC").
		Find(&universities).Error

	if err != nil {
		return nil, err
	}
	return universities, nil
}

func (u *PgUniverRepo) NewUniver(univer *model.University) (uint, error) {
	if err := u.db.Create(&univer).Error; err != nil {
		return 0, err
	}
	return univer.UniversityID, nil
}

func (u *PgUniverRepo) UpdateUniver(univer *model.University) error {
	if err := u.db.Save(univer).Error; err != nil {
		return err
	}
	return nil
}

func (u *PgUniverRepo) DeleteUniver(univer *model.University) error {
	if err := u.db.Delete(univer).Error; err != nil {
		return err
	}
	return nil
}

func (u *PgUniverRepo) ChangeUniverPopularity(university *model.University, value int) {
	university.Popularity += value
	u.db.Save(university)
}

func (u *PgUniverRepo) LikeUniver(universityID uint, userID uint) error {
	likedUniversity := model.LikedUniversities{
		UniversityID: universityID,
		UserID:       userID,
	}
	err := u.db.Create(&likedUniversity).Error
	return err
}

func (u *PgUniverRepo) DislikeUniver(universityID uint, userID uint) error {
	likedUniversity := model.LikedUniversities{
		UniversityID: universityID,
		UserID:       userID,
	}
	err := u.db.Delete(&likedUniversity).Error
	return err
}
