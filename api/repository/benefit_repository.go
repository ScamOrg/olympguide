package repository

import (
	"api/model"
	"gorm.io/gorm"
)

type IBenefitRepo interface {
	NewBenefit(benefit *model.Benefit) error
}

type PgBenefitRepo struct {
	db *gorm.DB
}

func NewPgBenefitRepo(db *gorm.DB) *PgBenefitRepo {
	return &PgBenefitRepo{db: db}
}

func (b *PgBenefitRepo) NewBenefit(benefit *model.Benefit) error {
	return nil
}
