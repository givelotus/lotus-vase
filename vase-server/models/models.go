package models

import (
	"time"

	"gorm.io/gorm"
)

type Location struct {
	ID        uint    `gorm:"primaryKey"`
	PushToken string  `json:"PushToken" gorm:"index"`
	Longitude float32 `json:"Longitude"`
	Latitude  float32 `json:"Latitude"`
	// Just want to log which address was being used since there's no direct
	// association between this and addresses, of which there could be multiple
	Address string `json:"Address"`

	CreatedAt time.Time
	UpdatedAt time.Time
	DeletedAt gorm.DeletedAt `gorm:"index"`
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
	DeletedAt gorm.DeletedAt `gorm:"index"`
}
