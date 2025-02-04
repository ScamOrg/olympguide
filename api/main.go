package main

import (
	"api/config"
	"api/handler/auth"
	"api/middleware"
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

	codeRepo := repository.NewRedisCodeRepo(redis)
	userRepo := repository.NewPgUserRepo(db)

	codeService := service.NewCodeService(codeRepo)
	userService := service.NewUserService(userRepo)

	authHandler := auth.NewHandler(userService, codeService)

	r := gin.Default()
	r.Use(sessions.Sessions("session", store))
	r = router.SetupRoutes(r, authHandler)

	serverAddress := fmt.Sprintf(":%d", cfg.ServerPort)
	log.Printf("Server listening on %s", serverAddress)
	if err = r.Run(serverAddress); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
