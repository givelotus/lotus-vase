package models

import (
	"time"

	"gorm.io/gorm"
)

type Location struct {
	gorm.Model
	PushToken string  `json:"PushToken" gorm:"index"`
	Longitude float32 `json:"Longitude"`
	Latitude  float32 `json:"Latitude"`

	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt gorm.DeletedAt
}

type Address struct {
	Type      string `json:"Type" gorm:"default:XPI"`
	PushToken string `json:"PushToken" gorm:"primaryKey"`
	Address   string `json:"Address" gorm:"primaryKey"`

	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt gorm.DeletedAt `gorm:"index"`
}

type User struct {
	PushToken string     `json:"PushToken" gorm:"primaryKey"`
	Addresses []Address  `json:"XPIAddresses" gorm:"foreignKey:PushToken;references:PushToken""`
	Location  []Location `json:"Location"  gorm:"foreignKey:PushToken;references:PushToken"`

	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt gorm.DeletedAt
}
