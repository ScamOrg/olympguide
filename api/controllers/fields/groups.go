package fields

import (
	"api/constants"
	"api/db"
	"api/models"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"net/http"
)

type FieldShortInfo struct {
	FieldID uint   `json:"field_id"`
	Name    string `json:"name"`
	Code    string `json:"code"`
	Degree  string `json:"degree"`
}
type GroupResponse struct {
	Name   string           `json:"name"`
	Code   string           `json:"code"`
	Fields []FieldShortInfo `json:"fields"`
}

func GetFields(c *gin.Context) {
	var groups []models.GroupField
	err := db.DB.Preload("Fields", func(db *gorm.DB) *gorm.DB {
		if degrees := c.QueryArray("degree"); len(degrees) > 0 {
			db = db.Where("degree IN (?)", degrees)
		}
		if name := c.Query("search"); name != "" {
			db = db.Where("name ILIKE ? OR code ILIKE ?", "%"+name+"%", "%"+name+"%")
		}
		return db
	}).Find(&groups).Error

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": constants.InternalServerError})
		return
	}
	var response []GroupResponse
	for _, group := range groups {
		if len(group.Fields) == 0 {
			continue
		}
		var fields []FieldShortInfo
		for _, field := range group.Fields {
			fields = append(fields, FieldShortInfo{
				FieldID: field.FieldID,
				Name:    field.Name,
				Code:    field.Code,
				Degree:  field.Degree,
			})
		}
		response = append(response, GroupResponse{
			Name:   group.Name,
			Code:   group.Code,
			Fields: fields,
		})
	}
	c.JSON(http.StatusOK, response)
}
