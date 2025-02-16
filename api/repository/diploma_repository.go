package repository

import (
	"api/dto"
	"api/model"
	"api/utils/constants"
	"context"
	"encoding/json"
	"github.com/go-redis/redis/v8"
	"gorm.io/gorm"
)

type IDiplomaRepo interface {
	NewDiploma(diploma *model.Diploma) error
	DeleteDiploma(diploma *model.Diploma) error
	GetDiplomaByID(diplomaID string) (*model.Diploma, error)
	GetDiplomasByUserID(userID uint) ([]model.Diploma, error)
	PublishUploadDiplomas(ctx context.Context, message *dto.UploadDiplomasMessage) error
}

type DiplomaRepo struct {
	db  *gorm.DB
	rdb *redis.Client
}

func NewDiplomaRepo(db *gorm.DB, redis *redis.Client) *DiplomaRepo {

	return &DiplomaRepo{db: db, rdb: redis}
}

func (d *DiplomaRepo) NewDiploma(diploma *model.Diploma) error {
	return d.db.Create(&diploma).Error
}

func (d *DiplomaRepo) DeleteDiploma(diploma *model.Diploma) error {
	return d.db.Delete(&diploma).Error
}

func (d *DiplomaRepo) GetDiplomaByID(diplomaID string) (*model.Diploma, error) {
	diploma := &model.Diploma{}
	err := d.db.Where("diploma_id = ?", diplomaID).First(diploma).Error
	if err != nil {
		return nil, err
	}
	return diploma, nil
}

func (d *DiplomaRepo) GetDiplomasByUserID(userID uint) ([]model.Diploma, error) {
	var diplomas []model.Diploma
	err := d.db.Preload("Olympiad").Where("user_id = ?", userID).
		Order("level DESC").
		Find(&diplomas).Error
	if err != nil {
		return nil, err
	}
	return diplomas, nil
}

func (d *DiplomaRepo) PublishUploadDiplomas(ctx context.Context, message *dto.UploadDiplomasMessage) error {
	msgJSON, err := json.Marshal(message)
	if err != nil {
		return err
	}
	return d.rdb.Publish(ctx, constants.DiplomaTopic, msgJSON).Err()
}
