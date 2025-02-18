package utils

import (
	"api/utils/constants"
	"context"
	"fmt"
	"github.com/go-redis/redis/v8"
	"log"
)

func ConnectRedis(cfg *Config) *redis.Client {
	redisAddress := fmt.Sprintf("%s:%d", cfg.RedisHost, cfg.RedisPort)
	log.Printf(cfg.RedisPassword)
	client := redis.NewClient(&redis.Options{
		Addr:     redisAddress,
		Password: cfg.RedisPassword,
		DB:       constants.RedisDBNum,
	})
	_, err := client.Ping(context.Background()).Result()
	if err != nil {
		log.Fatalf("Could not connect to Redis: %v", err)
	}
	return client
}
