package main

import (
	"log"

	"api/router"
	"api/utils"
)

func main() {
	cfg, err := utils.LoadConfig()
	if err != nil {
		log.Fatalf("Failed to load configuration: %v", err)
	}

	db, redis, store := initConnections(cfg)
	handlers := initHandlers(db, redis)
	mw := initMiddleware(db)

	Router := router.NewRouter(handlers, mw, store)
	Router.Run(cfg.ServerPort)
}
