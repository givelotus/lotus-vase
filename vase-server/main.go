package main

import (
	"github.com/gin-gonic/gin"
	"vase.givelotus.org/server/initializers"
	"vase.givelotus.org/server/models"
)

func main() {
	initializers.LoadEnvVariables()
	DB := initializers.ConnectToDB()
	defer DB.Close()
	r := gin.New()

	r.POST("/userinfo", func(c *gin.Context) {
		var json models.UserInfo
		c.BindJSON(&json)
		DB.Save(json)

		c.JSON(200, gin.H{
			"info": json,
		})
	})

	r.Run()
}
