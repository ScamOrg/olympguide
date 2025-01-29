package users

import (
	"api/controllers/handlers"
	"api/logic"
	"github.com/gin-gonic/gin"
	"net/http"
)

func LikeUniversity(c *gin.Context) {
	universityID := c.Param("id")
	userID, _ := c.MustGet("user_id").(uint)

	university, err := logic.GetUniversityByID(universityID)
	if err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}

	isLiked := logic.IsUserLikedUniversity(userID, university.UniversityID)
	if isLiked {
		c.JSON(http.StatusOK, gin.H{"message": "Already liked"})
		return
	}

	err = logic.LikeUniversity(userID, university.UniversityID)
	if err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}
	logic.IncrementUniversityPopularity(university)
	c.JSON(http.StatusOK, gin.H{"message": "Liked"})
}

func UnlikeUniversity(c *gin.Context) {
	universityID := c.Param("id")
	userID, _ := c.MustGet("user_id").(uint)

	university, err := logic.GetUniversityByID(universityID)
	if err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}

	isLiked := logic.IsUserLikedUniversity(userID, university.UniversityID)
	if !isLiked {
		c.JSON(http.StatusOK, gin.H{"message": "Already unliked"})
		return
	}

	if err := logic.UnlikeUniversity(userID, university.UniversityID); err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}
	logic.DecrementUniversityPopularity(university)
	c.JSON(http.StatusOK, gin.H{"message": "Unliked"})
}
