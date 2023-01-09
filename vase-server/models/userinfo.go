package models

import (
	"gorm.io/gorm"
)

type Location struct{
	Longitude string `json:"Longitude"`
	Latitude string `json:"Latitude"`
}

type Address struct{
	Index int `json:"Index"`
	Address string `json:"Address"`
}

type UserInfo struct {
	gorm.Model
	PushToken string `json:"PushToken"`
	XPIAddresses []Address `json:"XPIAddresses"`
	Location Location `json:"Location"`
}