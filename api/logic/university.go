package logic

import (
	"api/model"
	"api/utils"
)

func GetUniversityByID(universityID string) (*model.University, error) {
	var university model.University
	if err := utils.DB.Preload("Region").First(&university, universityID).Error; err != nil {
		return nil, err
	}
	return &university, nil
}

func GetUniversities(userID any, regionIDs []string, fromMyRegion bool, search string) ([]model.University, error) {
	var universities []model.University

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

func DeleteUniversity(university *model.University) error {
	if err := utils.DB.Delete(university).Error; err != nil {
		return err
	}
	return nil
}

func CreateUniversity(university *model.University) (uint, error) {
	if err := utils.DB.Create(&university).Error; err != nil {
		return 0, err
	}
	return university.UniversityID, nil
}

func UpdateUniversity(university *model.University) error {
	if err := utils.DB.Save(university).Error; err != nil {
		return err
	}
	return nil
}

func ChangeUniversityPopularity(university *model.University, value int) {
	university.Popularity += value
	utils.DB.Save(university)
}
