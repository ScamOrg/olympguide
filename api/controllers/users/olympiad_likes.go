package users

import (
	"api/controllers/handlers"
	"api/logic"
	"github.com/gin-gonic/gin"
	"net/http"
)

func LikeOlympiad(c *gin.Context) {
	olympiadID := c.Param("id")
	userID, _ := c.MustGet("user_id").(uint)

	olympiad, err := logic.GetOlympiadByID(olympiadID)
	if err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}

	isLiked := logic.IsUserLikedOlympiad(userID, olympiad.OlympiadID)
	if isLiked {
		c.JSON(http.StatusOK, gin.H{"message": "Already liked"})
		return
	}

	err = logic.LikeOlympiad(userID, olympiad.OlympiadID)
	if err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}
	logic.ChangeOlympiadPopularity(olympiad, main.LikePopularityIncrease)
	c.JSON(http.StatusOK, gin.H{"message": "Liked"})
}

func UnlikeOlympiad(c *gin.Context) {
	olympiadID := c.Param("id")
	userID, _ := c.MustGet("user_id").(uint)

	olympiad, err := logic.GetOlympiadByID(olympiadID)
	if err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}

	isLiked := logic.IsUserLikedOlympiad(userID, olympiad.OlympiadID)
	if !isLiked {
		c.JSON(http.StatusOK, gin.H{"message": "Already unliked"})
		return
	}

	if err = logic.UnlikeOlympiad(userID, olympiad.OlympiadID); err != nil {
		handlers.HandleUnknownError(c, err)
		return
	}
	logic.ChangeOlympiadPopularity(olympiad, main.LikePopularityDecrease)
	c.JSON(http.StatusOK, gin.H{"message": "Unliked"})
}
