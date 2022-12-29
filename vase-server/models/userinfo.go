package models

import (
	"gorm.io/gorm"
	"time"
)

type UserInfo struct {
	gorm.Model
	Token string
	Address string
	Longitude string
	Latitude string
}