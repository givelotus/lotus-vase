package models

import (
	"gorm.io/gorm"
)


type UserInfo struct {
	gorm.Model
	PushToken string
	Address string
	Location struct {
		Longitude string
		Latitude string
	}
}