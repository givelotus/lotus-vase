package main

import (
	"github.com/gin-gonic/gin"


	"vase.givelotus.org/server/models"
	"vase.givelotus.org/server/initializers"
)


func init(){
	initializers.LoadEnvVariables()
	initializers.ConnectToDB()
	
}

func main() {
	r := gin.New()

	r.POST("/userinfo", func(c *gin.Context){
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
