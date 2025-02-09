package constants

import "time"

const (
	EmailCodeTtl          = 3 * time.Minute
	MaxVerifyCodeAttempts = 3
)
const MaxSessionConn = 10

const RedisDBNum = 0

const (
	LikePopularityIncrease = 1
	LikePopularityDecrease = -1
)

const (
	EmailCodeTopic = "email_codes"
)
const (
	ContextUserID   = "user_id"
	ContextUniverID = "university_id"
)
