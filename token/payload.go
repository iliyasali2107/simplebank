package token

import (
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

type Payload struct {
	jwt.RegisteredClaims
	ID       uuid.UUID `json:"id"`
	Username string    `json:"username"`
}

func NewPayload(username string, duration time.Duration) (*Payload, error) {
	tokenID, err := uuid.NewRandom()
	if err != nil {
		return nil, err
	}

	payload := &Payload{
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(duration)),
			IssuedAt:  jwt.NewNumericDate(time.Now()),
		},
		ID:       tokenID,
		Username: username,
	}

	return payload, nil
}

func (payload *Payload) Validate() error {
	if time.Now().After(payload.ExpiresAt.Time) {
		return ErrExpiredToken
	}

	return nil
}
