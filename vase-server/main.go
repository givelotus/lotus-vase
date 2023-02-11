package main

import (
	"github.com/gin-gonic/gin"
	"vase.givelotus.org/server/initializers"
	"vase.givelotus.org/server/models"
)

type UserInfo struct {
	PushToken string  `json:"PushToken"`
	Longitude float32 `json:"Longitude"`
	Latitude  float32 `json:"Latitude"`
	Address   string  `json:"Address"`
}

func main() {
	initializers.LoadEnvVariables()
	DB := initializers.ConnectToDB()
	r := gin.New()

	r.POST("/userinfo", func(c *gin.Context) {
		var json UserInfo
		c.BindJSON(&json)

		DB.Save(&models.User{
			PushToken: json.PushToken,
		})
		DB.Save(&models.Location{
			PushToken: json.PushToken,
			Longitude: json.Longitude,
			Latitude:  json.Latitude,
			Address:   json.Address,
		})
		DB.Save(&models.Address{
			Type:      "XPI",
			PushToken: json.PushToken,
			Address:   json.Address,
		})

		c.JSON(200, gin.H{
			"info": json,
		})
	})

	r.Run()
}
