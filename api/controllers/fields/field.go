package fields

import (
	"api/constants"
	"api/db"
	"api/models"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
)

type GroupShortInfo struct {
	Name string `json:"name"`
	Code string `json:"code"`
}

type FieldResponse struct {
	FieldID uint           `json:"field_id"`
	Name    string         `json:"name"`
	Code    string         `json:"code"`
	Degree  string         `json:"degree"`
	Group   GroupShortInfo `json:"group"`
}

func GetFieldByID(c *gin.Context) {
	idParam := c.Param("id")
	fieldID, err := strconv.Atoi(idParam)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": constants.InvalidRequest})
		return
	}
	var field models.Field

	result := db.DB.Preload("Group").First(&field, fieldID)
	if result.Error != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": constants.DataNotFound})
		return
	}
	request := FieldResponse{
		FieldID: field.FieldID,
		Name:    field.Name,
		Code:    field.Code,
		Degree:  field.Degree,
		Group: GroupShortInfo{
			Name: field.Group.Name,
			Code: field.Group.Code,
		},
	}
	c.JSON(http.StatusOK, request)
}
