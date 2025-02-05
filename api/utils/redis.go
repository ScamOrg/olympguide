package utils

import (
	"api/utils/constants"
	"fmt"
	"github.com/go-redis/redis/v8"
)

func ConnectRedis(cfg *Config) *redis.Client {
	redisAddress := fmt.Sprintf("%s:%d", cfg.RedisHost, cfg.RedisPort)
	redisDB := redis.NewClient(&redis.Options{
		Addr: redisAddress,
		DB:   constants.RedisDBNum,
	})
	return redisDB
}
