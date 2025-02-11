package repository

import (
	"api/model"
	"gorm.io/gorm"
)

type IFacultyRepo interface {
	NewFaculty(faculty *model.Faculty) (uint, error)
	UpdateFaculty(faculty *model.Faculty) error
	DeleteFaculty(faculty *model.Faculty) error
	GetFacultyByID(facultyID string) (*model.Faculty, error)
	GetFacultiesByUniversityID(universityID string) ([]model.Faculty, error)
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
	if err := u.db.Create(&faculty).Error; err != nil {
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
