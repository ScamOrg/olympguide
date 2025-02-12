package repository

import (
	"api/utils/constants"
	"context"
	"encoding/json"
	"github.com/go-redis/redis/v8"
	"strconv"
	"time"
)

type ICodeRepo interface {
	CodeExists(ctx context.Context, email string) (bool, error)
	SetCode(ctx context.Context, email, code string, attempts int, ttl time.Duration) error
	GetCodeInfo(ctx context.Context, email string) (string, int, error)
	GetCodeTTL(ctx context.Context, email string) (time.Duration, error)
	DeleteCode(ctx context.Context, email string) error
	SendCode(ctx context.Context, email, code string) error
	DecreaseCodeAttempt(ctx context.Context, email string) error
}

type RedisCodeRepo struct {
	rdb *redis.Client
}

func NewRedisCodeRepo(redis *redis.Client) *RedisCodeRepo {
	return &RedisCodeRepo{rdb: redis}
}

func (e *RedisCodeRepo) CodeExists(ctx context.Context, email string) (bool, error) {
	exists, err := e.rdb.Exists(ctx, email).Result()
	return exists == 1, err
}

func (e *RedisCodeRepo) GetCodeTTL(ctx context.Context, email string) (time.Duration, error) {
	return e.rdb.TTL(ctx, email).Result()
}

func (e *RedisCodeRepo) SetCode(ctx context.Context, email, code string, attempts int, duration time.Duration) error {
	err := e.rdb.HSet(ctx, email, map[string]interface{}{
		"code":     code,
		"attempts": attempts,
	}).Err()
	if err != nil {
		return err
	}
	return e.rdb.Expire(ctx, email, duration).Err()
}

// GetCodeInfo if err == nil:
// attempts = -1 - code not exists
// attempts = 0 - too many attempts
func (e *RedisCodeRepo) GetCodeInfo(ctx context.Context, email string) (string, int, error) {
	data, err := e.rdb.HGetAll(ctx, email).Result()
	if err != nil {
		return "", 0, err
	} else if len(data) == 0 {
		return "", -1, nil
	}
	storedCode := data["code"]
	attempts, err := strconv.Atoi(data["attempts"])
	if err != nil {
		return "", 0, err
	}
	return storedCode, attempts, nil
}

func (e *RedisCodeRepo) DeleteCode(ctx context.Context, email string) error {
	return e.rdb.Del(ctx, email).Err()
}

func (e *RedisCodeRepo) SendCode(ctx context.Context, email, code string) error {
	msg := Message{email, code}
	msgJSON, _ := json.Marshal(msg)
	return e.rdb.Publish(ctx, constants.EmailCodeTopic, msgJSON).Err()
}

func (e *RedisCodeRepo) DecreaseCodeAttempt(ctx context.Context, email string) error {
	return e.rdb.HIncrBy(ctx, email, "attempts", -1).Err()
}

type Message struct {
	Email string `json:"email"`
	Code  string `json:"code"`
}
