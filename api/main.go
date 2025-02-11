package main

import (
	"api/handler"
	"api/middleware"
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
	olympRepo := repository.NewPgOlympRepo(db)
	adminRepo := repository.NewPgAdminRepo(db)
	facultyRepo := repository.NewPgFacultyRepo(db)
	programRepo := repository.NewPgProgramRepo(db)

	authService := service.NewAuthService(codeRepo, userRepo, regionRepo)
	univerService := service.NewUniverService(univerRepo, regionRepo)
	fieldService := service.NewFieldService(fieldRepo)
	olympService := service.NewOlympService(olympRepo)
	metaService := service.NewMetaService(regionRepo, olympRepo)
	userService := service.NewUserService(userRepo)
	adminService := service.NewAdminService(adminRepo)
	facultyService := service.NewFacultyService(facultyRepo)
	programService := service.NewProgramService(programRepo)

	authHandler := handler.NewAuthHandler(authService)
	univerHandler := handler.NewUniverHandler(univerService)
	fieldHandler := handler.NewFieldHandler(fieldService)
	olympHandler := handler.NewOlympHandler(olympService)
	metaHandler := handler.NewMetaHandler(metaService)
	userHandler := handler.NewUserHandler(userService)
	facultyHandler := handler.NewFacultyHandler(facultyService)
	programHandler := handler.NewProgramHandler(programService)

	mw := middleware.NewMw(adminService)

	mainRouter := router.NewRouter(authHandler, univerHandler, fieldHandler,
		olympHandler, metaHandler, userHandler,
		facultyHandler, programHandler, mw)

	r := gin.Default()
	r.Use(sessions.Sessions("session", store))

	mainRouter.SetupRoutes(r)

	serverAddress := fmt.Sprintf(":%d", cfg.ServerPort)
	log.Printf("Server listening on %s", serverAddress)
	if err = r.Run(serverAddress); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
