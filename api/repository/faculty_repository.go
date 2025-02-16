package repository

import (
	"api/model"
	"api/utils/errs"
	"errors"
	"github.com/jackc/pgx/v5/pgconn"
	"gorm.io/gorm"
)

type IFacultyRepo interface {
	NewFaculty(faculty *model.Faculty) (uint, error)
	UpdateFaculty(faculty *model.Faculty) error
	DeleteFaculty(faculty *model.Faculty) error
	GetFacultyByID(facultyID string) (*model.Faculty, error)
	GetFacultiesByUniversityID(universityID string) ([]model.Faculty, error)
	ExistsInUniversity(facultyID, universityID uint) bool
}

type PgFacultyRepo struct {
	db *gorm.DB
}

func NewPgFacultyRepo(db *gorm.DB) *PgFacultyRepo {
	return &PgFacultyRepo{db: db}
}

func (u *PgFacultyRepo) GetFacultiesByUniversityID(universityID string) ([]model.Faculty, error) {
	var faculties []model.Faculty
	err := u.db.Where("university_id = ?", universityID).Find(&faculties).Error
	return faculties, err
}

func (u *PgFacultyRepo) GetFacultyByID(facultyID string) (*model.Faculty, error) {
	faculty := &model.Faculty{}
	err := u.db.Where("faculty_id = ?", facultyID).First(faculty).Error
	if err != nil {
		return nil, err
	}
	return faculty, nil
}

func (u *PgFacultyRepo) NewFaculty(faculty *model.Faculty) (uint, error) {
	err := u.db.Create(&faculty).Error
	if err != nil {
		var pgErr *pgconn.PgError
		if errors.As(err, &pgErr) {
			if pgErr.Code == "23505" {
				return 0, errs.FacultyAlreadyExists
			}
		}
		return 0, err
	}
	return faculty.FacultyID, nil
}

func (u *PgFacultyRepo) UpdateFaculty(faculty *model.Faculty) error {
	return u.db.Save(faculty).Error
}

func (u *PgFacultyRepo) DeleteFaculty(faculty *model.Faculty) error {
	return u.db.Delete(faculty).Error
}

func (u *PgFacultyRepo) ExistsInUniversity(facultyID, universityID uint) bool {
	var count int64
	u.db.Model(&model.Faculty{}).
		Where("faculty_id = ? AND university_id = ?", facultyID, universityID).
		Count(&count)
	return count > 0
}
