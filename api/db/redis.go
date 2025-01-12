package db

import (
	"api/config"
	"fmt"
	"github.com/go-redis/redis/v8"
	"log"
)

var Redis *redis.Client

func ConnectRedis(cfg *config.Config) {
	redisAddress := fmt.Sprintf("%s:%d", cfg.RedisHost, cfg.RedisPort)
	Redis = redis.NewClient(&redis.Options{
		Addr: redisAddress,
		DB:   0,
	})
	log.Println("Connected to Redis")
}
