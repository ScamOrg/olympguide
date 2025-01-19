package universities

import (
	"api/constants"
	"api/db"
	"api/models"
	"errors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"log"
	"net/http"
)

type UniversityRequest struct {
	Name        string `json:"name" binding:"required"`
	Logo        string `json:"logo"`
	Email       string `json:"email"`
	Site        string `json:"site"`
	Description string `json:"description"`
	RegionID    uint   `json:"region_id" binding:"required"`
}

type UniversityShortResponse struct {
	UniversityID uint   `json:"university_id"`
	Name         string `json:"name"`
	Logo         string `json:"logo"`
	Region       string `json:"region"`
	Like         bool   `json:"like"`
}

type UniversityResponse struct {
	Email       string `json:"email"`
	Site        string `json:"site"`
	Description string `json:"description"`
	UniversityShortResponse
}

func GetUniversities(c *gin.Context) {
	var universities []models.University
	if err := db.DB.Preload("Region").Find(&universities).Error; err != nil {
		log.Println(err.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		return
	}

	userID, exists := c.Get("user_id")
	var response []UniversityShortResponse

	for _, university := range universities {
		like := false
		if exists {
			var likedUniversity models.LikedUniversities
			if err := db.DB.Where("university_id = ? AND user_id = ?", university.UniversityID, userID).First(&likedUniversity).Error; err == nil {
				like = true
			}
		}
		response = append(response, UniversityShortResponse{
			Name:   university.Name,
			Logo:   university.Logo,
			Region: university.Region.Name,
			Like:   like,
		})
	}
	c.JSON(http.StatusOK, response)
}

func GetUniversityByID(c *gin.Context) {
	universityID := c.Param("id")

	var university models.University
	if err := db.DB.Preload("Region").First(&university, universityID).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": constants.DataNotFound})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		}
		return
	}

	university.Popularity += 1
	userID, exists := c.Get("user_id")
	like := false
	if exists {
		var likedUniversity models.LikedUniversities
		if err := db.DB.Where("university_id = ? AND user_id = ?", universityID, userID).First(&likedUniversity).Error; err == nil {
			like = true
		}
	}

	response := UniversityResponse{
		Email:       university.Email,
		Site:        university.Site,
		Description: university.Description,
		UniversityShortResponse: UniversityShortResponse{
			UniversityID: university.UniversityID,
			Name:         university.Name,
			Logo:         university.Logo,
			Region:       university.Region.Name,
			Like:         like,
		},
	}
	c.JSON(http.StatusOK, response)
}

func CreateUniversity(c *gin.Context) {
	var request UniversityRequest
	if err := c.ShouldBind(&request); err != nil {
		log.Println(err.Error())
		c.JSON(http.StatusBadRequest, gin.H{"error": constants.InvalidRequest})
		return
	}

	var regionExists bool
	db.DB.Raw("SELECT EXISTS(SELECT 1 FROM olympguide.region WHERE region_id = ?)", request.RegionID).Scan(&regionExists)
	if !regionExists {
		c.JSON(http.StatusBadRequest, gin.H{"error": constants.RegionNotFound})
		return
	}

	university := models.University{
		Name:        request.Name,
		Logo:        request.Logo,
		Site:        request.Site,
		Email:       request.Email,
		Description: request.Description,
		RegionID:    request.RegionID,
	}

	result := db.DB.Create(&university)
	if result.Error != nil {
		log.Println(result.Error.Error())
		c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"university_id": university.UniversityID})
}

func DeleteUniversityByID(c *gin.Context) {
	id := c.Param("id")
	var university models.University
	if err := db.DB.First(&university, id).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": constants.DataNotFound})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		}
		return
	}

	if err := db.DB.Delete(&university).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		return
	}
	c.Status(http.StatusOK)
}

func UpdateUniversityByID(c *gin.Context) {
	universityID := c.Param("id")
	var request UniversityRequest
	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": constants.InvalidRequest})
		return
	}

	var university models.University
	if err := db.DB.First(&university, universityID).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": constants.DataNotFound})
		} else {
			c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		}
		return
	}

	university.Name = request.Name
	university.Logo = request.Logo
	university.Email = request.Email
	university.Site = request.Site
	university.Description = request.Description
	university.RegionID = request.RegionID

	if err := db.DB.Save(&university).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		return
	}

	c.Status(http.StatusOK)
}
