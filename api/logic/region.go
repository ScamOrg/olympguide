package logic

import (
	"api/model"
	"api/utils"
)

func IsRegionExists(regionID uint) bool {
	var regionExists bool
	utils.DB.Raw("SELECT EXISTS(SELECT 1 FROM olympguide.region WHERE region_id = ?)", regionID).Scan(&regionExists)
	return regionExists
}

func GetUserRegionID(userID uint) uint {
	var user model.User
	if err := utils.DB.Select("region_id").First(&user, userID).Error; err != nil {
		return 0
	}
	return user.RegionID
}

func GetRegions() ([]model.Region, error) {
	var regions []model.Region

	if err := utils.DB.Find(&regions).Error; err != nil {
		return nil, err
	}
	return regions, nil
}

func GetRegionByID(regionID uint) (*model.Region, error) {
	var region model.Region
	if err := utils.DB.First(&region, regionID).Error; err != nil {
		return nil, err
	}
	return &region, nil
}
