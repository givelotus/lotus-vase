package main

import (
	"vase.givelotus.org/server/initializers"
	"vase.givelotus.org/server/models"
)

func main() {
	initializers.LoadEnvVariables()
	DB := initializers.ConnectToDB()
	DB.AutoMigrate(models.User{}, models.Address{}, models.Location{})
}
