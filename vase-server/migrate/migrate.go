package main

import (
	"vase.givelotus.org/server/initializers"
	"vase.givelotus.org/server/models"
)

func init(){
	initializers.LoadEnvVariables()
	initializers.ConnectToDB()
}


func main(){
	initializers.DB.AutoMigrate(&models.UserInfo{})
} 