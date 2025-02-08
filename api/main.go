package main

import (
	"api/handler"
	"api/repository"
	"api/service"
	"fmt"
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
	"log"

	"api/router"
	"api/utils"
)

func main() {
	cfg, err := utils.LoadConfig()
	if err != nil {
		log.Fatalf("Failed to load configuration: %v", err)
	}

	db := utils.ConnectPostgres(cfg)
	redis := utils.ConnectRedis(cfg)
	store := utils.ConnectSessionStore(cfg)

	codeRepo := repository.NewRedisCodeRepo(redis)
	userRepo := repository.NewPgUserRepo(db)
	regionRepo := repository.NewPgRegionRepo(db)
	univerRepo := repository.NewPgUniverRepo(db)
	fieldRepo := repository.NewPgFieldRepo(db)

	authService := service.NewAuthService(codeRepo, userRepo, regionRepo)
	univerService := service.NewUniverService(univerRepo, regionRepo)
	fieldService := service.NewFieldService(fieldRepo)

	authHandler := handler.NewAuthHandler(authService)
	univerHandler := handler.NewUniverHandler(univerService)
	fieldHandler := handler.NewFieldHandler(fieldService)

	r := gin.Default()
	r.Use(sessions.Sessions("session", store))
	r = router.SetupRoutes(r, authHandler, univerHandler, fieldHandler)

	serverAddress := fmt.Sprintf(":%d", cfg.ServerPort)
	log.Printf("Server listening on %s", serverAddress)
	if err = r.Run(serverAddress); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
