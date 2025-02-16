package main

import (
	"api/handler"
	"api/middleware"
	"api/repository"
	"api/service"
	"api/utils"
	"github.com/gin-contrib/sessions"
	"github.com/go-redis/redis/v8"
	"gorm.io/gorm"
)

func initConnections(cfg *utils.Config) (*gorm.DB, *redis.Client, sessions.Store) {
	db := utils.ConnectPostgres(cfg)
	rdb := utils.ConnectRedis(cfg)
	store := utils.ConnectSessionStore(cfg)
	return db, rdb, store
}

func initHandlers(db *gorm.DB, redis *redis.Client) *handler.Handlers {
	codeRepo := repository.NewRedisCodeRepo(redis)
	userRepo := repository.NewPgUserRepo(db)
	regionRepo := repository.NewPgRegionRepo(db)
	univerRepo := repository.NewPgUniverRepo(db)
	fieldRepo := repository.NewPgFieldRepo(db)
	olympRepo := repository.NewPgOlympRepo(db)
	facultyRepo := repository.NewPgFacultyRepo(db)
	programRepo := repository.NewPgProgramRepo(db)
	diplomaRepo := repository.NewDiplomaRepo(db, redis)

	authService := service.NewAuthService(codeRepo, userRepo, regionRepo)
	univerService := service.NewUniverService(univerRepo, regionRepo)
	fieldService := service.NewFieldService(fieldRepo)
	olympService := service.NewOlympService(olympRepo)
	metaService := service.NewMetaService(regionRepo, olympRepo, programRepo)
	userService := service.NewUserService(userRepo)
	facultyService := service.NewFacultyService(facultyRepo, univerRepo)
	programService := service.NewProgramService(programRepo, univerRepo, facultyRepo, fieldRepo)
	diplomaService := service.NewDiplomaService(diplomaRepo, userRepo, olympRepo)

	return &handler.Handlers{
		Auth:    handler.NewAuthHandler(authService),
		Univer:  handler.NewUniverHandler(univerService),
		Field:   handler.NewFieldHandler(fieldService),
		Olymp:   handler.NewOlympHandler(olympService),
		Meta:    handler.NewMetaHandler(metaService),
		User:    handler.NewUserHandler(userService),
		Faculty: handler.NewFacultyHandler(facultyService),
		Program: handler.NewProgramHandler(programService),
		Diploma: handler.NewDiplomaHandler(diplomaService),
	}
}

func initMiddleware(db *gorm.DB) *middleware.Mw {
	adminRepo := repository.NewPgAdminRepo(db)
	adminService := service.NewAdminService(adminRepo)
	return middleware.NewMw(adminService)
}
