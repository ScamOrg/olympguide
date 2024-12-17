package config

import (
	"fmt"
	"github.com/joho/godotenv"
	"log"
	"os"
	"strconv"
)

type Config struct {
	DBHost     string
	DBPort     int
	DBUser     string
	DBPassword string
	DBName     string
	ServerPort int
}

func LoadConfig() (*Config, error) {
	err := godotenv.Load("../.env")
	if err != nil {
		log.Println("Error loading .env file")
	}

	dbPortStr := os.Getenv("DB_PORT")
	serverPortStr := os.Getenv("API_PORT")

	dbPort, err := strconv.Atoi(dbPortStr)
	if err != nil {
		return nil, fmt.Errorf("invalid DB_PORT: %w", err)
	}

	serverPort, err := strconv.Atoi(serverPortStr)
	if err != nil {
		return nil, fmt.Errorf("invalid SERVER_PORT: %w", err)
	}

	cfg := &Config{
		DBHost:     os.Getenv("DB_HOST"),
		DBPort:     dbPort,
		DBUser:     os.Getenv("DB_USER"),
		DBPassword: os.Getenv("DB_PASSWORD"),
		DBName:     os.Getenv("DB_NAME"),
		ServerPort: serverPort,
	}

	return cfg, nil
}
