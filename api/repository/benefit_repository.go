package repository

import (
	"api/model"
	"gorm.io/gorm"
)

type IBenefitRepo interface {
	NewBenefit(benefit *model.Benefit) error
	DeleteBenefit(benefitID string) error
}

type PgBenefitRepo struct {
	db *gorm.DB
}

func NewPgBenefitRepo(db *gorm.DB) *PgBenefitRepo {
	return &PgBenefitRepo{db: db}
}

func (b *PgBenefitRepo) NewBenefit(benefit *model.Benefit) error {
	return b.db.Create(&benefit).Error
}

func (b *PgBenefitRepo) DeleteBenefit(benefitID string) error {
	return b.db.Delete(&model.Benefit{}, benefitID).Error
}
