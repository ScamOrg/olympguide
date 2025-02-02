package logic

import (
	"api/utils"
	"context"
	"encoding/json"
	"time"
)

type Message struct {
	Email string `json:"email"`
	Code  string `json:"code"`
}

func IsCodeAlreadySent(ctx context.Context, email string) (bool, time.Duration, error) {
	exists, err := utils.Redis.Exists(ctx, email).Result()
	if err != nil {
		return false, 0, err
	}

	var ttl time.Duration
	if exists == 1 {
		ttl, err = utils.Redis.TTL(ctx, email).Result()
		if err != nil {
			return false, 0, err
		}
	}
	return exists == 1, ttl, nil
}

func SaveCodeToRedis(ctx context.Context, email, code string) error {
	err := utils.Redis.HSet(ctx, email, map[string]interface{}{
		"code":     code,
		"attempts": 0,
	}).Err()
	if err != nil {
		return err
	}
	return utils.Redis.Expire(ctx, email, EmailCodeTtl*time.Minute).Err()
}

func GetCodeAndAttempts(ctx context.Context, email string) (map[string]string, error) {
	return utils.Redis.HGetAll(ctx, email).Result()
}

func SendCodeViaPubSub(ctx context.Context, email, code string) error {
	msg := Message{email, code}
	msgJSON, _ := json.Marshal(msg)
	return utils.Redis.Publish(ctx, "email_codes", msgJSON).Err()
}

func DeleteCode(ctx context.Context, email string) error {
	return utils.Redis.Del(ctx, email).Err()
}

func IncrementAttempts(ctx context.Context, email string) error {
	return utils.Redis.HIncrBy(ctx, email, "attempts", 1).Err()
}
