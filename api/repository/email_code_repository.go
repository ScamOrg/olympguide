package repository

import (
	"context"
	"github.com/go-redis/redis/v8"
)

type EmailCodeRepository interface {
	IsCodeExists(ctx context.Context, email string) (bool, error)
	SetCode(ctx context.Context, email, code string, attempts int) error
	GetCodeInfo(ctx context.Context, email string) (string, int, error)
	DeleteCode(ctx context.Context, email string) error
	SetCodeTTL(ctx context.Context, email, code string, ttl int) error
	GetCodeTTL(ctx context.Context, email string) (int, error)
	SendCode(ctx context.Context, email, code string) error
	DecreaseCodeAttempt(ctx context.Context, email, code string) error
}

type EmailCodeRepositoryImpl struct {
	rdb *redis.Client
}

func NewEmailCodeRepository(redis *redis.Client) *EmailCodeRepositoryImpl {
	return &EmailCodeRepositoryImpl{rdb: redis}
}
