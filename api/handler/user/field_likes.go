package user

import (
	"api/handler/errors"
	"api/logic"
	"github.com/gin-gonic/gin"
	"net/http"
)

func LikeField(c *gin.Context) {
	fieldID := c.Param("id")
	userID, _ := c.MustGet("user_id").(uint)

	field, err := logic.GetFieldByID(fieldID)
	if err != nil {
		err.HandleUnknownError(c, err)
		return
	}

	isLiked := logic.IsUserLikedField(userID, field.FieldID)
	if isLiked {
		c.JSON(http.StatusOK, gin.H{"message": "Already liked"})
		return
	}

	err = logic.LikeField(userID, field.FieldID)
	if err != nil {
		err.HandleUnknownError(c, err)
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Liked"})
}

func UnlikeField(c *gin.Context) {
	fieldID := c.Param("id")
	userID, _ := c.MustGet("user_id").(uint)

	field, err := logic.GetFieldByID(fieldID)
	if err != nil {
		err.HandleUnknownError(c, err)
		return
	}

	isLiked := logic.IsUserLikedField(userID, field.FieldID)
	if !isLiked {
		c.JSON(http.StatusOK, gin.H{"message": "Already unliked"})
		return
	}

	if err = logic.UnlikeField(userID, field.FieldID); err != nil {
		err.HandleUnknownError(c, err)
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Unliked"})
}
