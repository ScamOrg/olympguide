package constants

import "time"

const (
	EmailCodeTtl          = 3 * time.Minute
	MaxVerifyCodeAttempts = 3
)
const MaxSessionConn = 10

const RedisDBNum = 0

const (
	LikeUniverPopularIncr = 10
	LikeUniverPopularDecr = -10
	// LikeOlympPopularIncr LikeProgramUniverPopularIncr = 1
	// LikeProgramUniverPopularDecr = -1
	LikeOlympPopularIncr   = 5
	LikeOlympPopularDecr   = -5
	LikeProgramPopularIncr = 5
	LikeProgramPopularDecr = -5
)

const (
	EmailCodeTopic = "auth.email.code"
	DiplomaTopic   = "user.diplomas.upload"
)
const (
	ContextUserID   = "user_id"
	ContextUniverID = "university_id"
)
