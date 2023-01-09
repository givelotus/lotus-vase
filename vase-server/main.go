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
		var json models.UserInfo
		c.BindJSON(&json)
		

		c.JSON(200, gin.H{
			"info": json,
		})
	})

	r.Run()
}
