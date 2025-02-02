package main

import (
	"api/config"
	"api/repository"
	"api/service"
	"fmt"
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"log"

	"api/router"
	"api/utils"
)

func main() {
	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("Failed to load configuration: %v", err)
	}

	db := utils.ConnectPostgres(cfg)
	redis := utils.ConnectRedis(cfg)
	store := utils.ConnectSessionStore(cfg)

	r := gin.Default()
	r.Use(sessions.Sessions("session", store))

	codeRepo := repository.NewEmailCodeRepository(redis)
	codeService := service.NewCodeService(codeRepo)
	userHandler := handler.NewUserHandler(userService)

	serverAddress := fmt.Sprintf(":%d", cfg.ServerPort)
	log.Printf("Server listening on %s", serverAddress)
	if err = r.Run(serverAddress); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
