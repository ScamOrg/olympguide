package logic

import (
	"api/models"
	"api/utils"
)

func GetUniversityByID(universityID string) (*models.University, error) {
	var university models.University
	if err := utils.DB.Preload("Region").First(&university, universityID).Error; err != nil {
		return nil, err
	}
	return &university, nil
}

func GetUniversities(userID any, regionIDs []string, fromMyRegion bool, search string) ([]models.University, error) {
	var universities []models.University

	query := utils.DB.Preload("Region")

	if uintUserID, ok := userID.(uint); ok && fromMyRegion {
		userRegionID := GetUserRegionID(uintUserID)
		query = query.Where("region_id = ?", userRegionID)
	} else if len(regionIDs) > 0 {
		query = query.Where("region_id IN (?)", regionIDs)
	}

	if search != "" {
		query = query.Where("name ILIKE ?", "%"+search+"%")
	}

	if err := query.Order("popularity DESC").Find(&universities).Error; err != nil {
		return nil, err
	}

	return universities, nil
}

func DeleteUniversity(university *models.University) error {
	if err := utils.DB.Delete(university).Error; err != nil {
		return err
	}
	return nil
}

func CreateUniversity(university *models.University) (uint, error) {
	if err := utils.DB.Create(&university).Error; err != nil {
		return 0, err
	}
	return university.UniversityID, nil
}

func UpdateUniversity(university *models.University) error {
	if err := utils.DB.Save(university).Error; err != nil {
		return err
	}
	return nil
}

func IncrementUniversityPopularity(university *models.University) {
	university.Popularity += 1
	utils.DB.Save(university)
}

func DecrementUniversityPopularity(university *models.University) {
	university.Popularity -= 1
	utils.DB.Save(university)
}
