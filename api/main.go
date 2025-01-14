package main

import (
	"fmt"
	"log"

	"api/config"
	"api/db"
	"api/routers"
)

func main() {
	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("Failed to load configuration: %v", err)
	}
	db.ConnectDB(cfg)
	db.ConnectRedis(cfg)
	r := routers.SetupRouter(cfg)
	serverAddress := fmt.Sprintf(":%d", cfg.ServerPort)
	log.Printf("Server listening on %s", serverAddress)
	if err := r.Run(serverAddress); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
