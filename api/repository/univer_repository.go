package repository

import (
	"api/model"
	"api/utils/errs"
	"errors"
	"github.com/jackc/pgx/v5/pgconn"
	"gorm.io/gorm"
	"log"
)

type IUniverRepo interface {
	UniverExists(univerID uint) bool
	GetUniver(universityID string, userID any) (*model.University, error)
	GetUnivers(search string, regionIDs []string, userID any) ([]model.University, error)
	GetLikedUnivers(userID uint) ([]model.University, error)
	NewUniver(univer *model.University) (uint, error)
	UpdateUniver(univer *model.University) error
	DeleteUniver(univer *model.University) error
	ChangeUniverPopularity(university *model.University, value int)
	LikeUniver(universityID uint, userID uint) error
	DislikeUniver(universityID uint, userID uint) error
	Exists(universityID uint) bool
}

type PgUniverRepo struct {
	db *gorm.DB
}

func NewPgUniverRepo(db *gorm.DB) *PgUniverRepo {
	return &PgUniverRepo{db: db}
}

func (u *PgUniverRepo) UniverExists(univerID uint) bool {
	var univerExists bool
	u.db.Raw("SELECT EXISTS(SELECT 1 FROM olympguide.university WHERE university_id = ?)", univerID).Scan(&univerExists)
	return univerExists
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
	err := u.db.Create(&univer).Error
	if err != nil {
		var pgErr *pgconn.PgError
		if errors.As(err, &pgErr) {
			log.Println("Code:", pgErr.Code)
			if pgErr.Code == "23505" {
				return 0, errs.UniverAlreadyExists
			}
		}
		return 0, err
	}
	return univer.UniversityID, nil
}

func (u *PgUniverRepo) UpdateUniver(univer *model.University) error {
	return u.db.Save(univer).Error
}

func (u *PgUniverRepo) DeleteUniver(univer *model.University) error {
	return u.db.Delete(univer).Error
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

func (u *PgUniverRepo) Exists(universityID uint) bool {
	var count int64
	u.db.Model(&model.University{}).Where("university_id = ?", universityID).Count(&count)
	return count > 0
}
