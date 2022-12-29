package main

import (
	"vase.givelotus.org/server/models"
	"github.com/gin-gonic/gin"
	"fmt"
)

func main() {
	r := gin.New()

	r.POST("/userinfo", func(c *gin.Context){
		fmt.Print("heee")
		var body struct {
			Token string
			Address string
			Longitude string
			Latitude string
		}
	
		c.Bind(&body)
	
		info := models.UserInfo{Token: body.Token, Address: body.Address, Longitude: body.Longitude, Latitude: body.Latitude}
	
		c.JSON(200, gin.H{
			"info": info,
		})
	})

	r.Run()
}
