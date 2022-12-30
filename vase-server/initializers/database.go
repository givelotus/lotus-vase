package initializers

import (
	"log"
	"fmt"
	"os"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectToDB(){
	var err error
	dsn := os.Getenv("DB_STRING")
	DB, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})

	if err != nil{
		log.Fatal("Failed to connect to database")
	} 
	fmt.Print(DB)

}