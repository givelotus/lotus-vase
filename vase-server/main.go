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
			PushToken string
			Address string
			Location struct{
				Longitude string
				Latitude string
			}
		}
		
		c.Bind(&body)
	
		info := models.UserInfo{PushToken: body.PushToken, Address: body.Address, Location: body.Location}
	
		c.JSON(200, gin.H{
			"info": info,
		})
	})

	r.Run("localhost:8080")
}
