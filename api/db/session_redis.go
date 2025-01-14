package db

import (
	"api/config"
	"api/constants"
	"fmt"
	"github.com/gin-contrib/sessions"
	"github.com/gin-contrib/sessions/redis"
	"github.com/gin-gonic/gin"
	"log"
)

func UseRedisSession(r *gin.Engine, cfg *config.Config) {
	redisAddress := fmt.Sprintf("%s:%d", cfg.RedisHost, cfg.RedisPort)
	store, err := redis.NewStore(constants.MAX_SESSION_CONN, "tcp", redisAddress, "", []byte("og_secret"))
	if err != nil {
		log.Fatal(err)
	}
	r.Use(sessions.Sessions("session", store))
}
