package utils

import (
	"api/config"
	"api/constants"
	"fmt"
	"github.com/gin-contrib/sessions"
	"github.com/gin-contrib/sessions/redis"
	"log"
)

func ConnectSessionStore(cfg *config.Config) sessions.Store {
	redisAddress := fmt.Sprintf("%s:%d", cfg.RedisHost, cfg.RedisPort)
	store, err := redis.NewStore(constants.MaxSessionConn, "tcp", redisAddress, "", []byte("og_secret"))
	if err != nil {
		log.Fatalf("Could not connect to store: %v", err)
	}
	return store
}
