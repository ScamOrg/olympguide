package logic

import (
	"api/models"
	"api/utils"
)

type OlympService struct {
	repo
}

func (s *OlympService) GetOlympiadByID(olympiadID string) (*models.Olympiad, error) {
	var olympiad models.Olympiad
	if err := utils.DB.First(&olympiad, olympiadID).Error; err != nil {
		return nil, err
	}
	return &olympiad, nil
}

func GetOlympiads(levels []string, profiles []string, name string, sortBy string, order string) ([]models.Olympiad, error) {
	var olympiads []models.Olympiad
	query := utils.DB.Model(&models.Olympiad{})

	if len(levels) > 0 {
		query = query.Where("level IN (?)", levels)
	}
	if len(profiles) > 0 {
		query = query.Where("profile IN (?)", profiles)
	}
	if name != "" {
		query = query.Where("name ILIKE ?", "%"+name+"%")
	}

	allowedSortFields := map[string]bool{
		"level":   true,
		"profile": true,
		"name":    true,
	}

	if allowedSortFields[sortBy] {
		if order != "asc" && order != "desc" {
			order = "asc"
		}
		query = query.Order(sortBy + " " + order)
	} else {
		query = query.Order("popularity DESC")
	}

	if err := query.Find(&olympiads).Error; err != nil {
		return nil, err
	}

	return olympiads, nil
}

func ChangeOlympiadPopularity(olympiad *models.Olympiad, value int) {
	olympiad.Popularity += value
	utils.DB.Save(olympiad)
}
