package controllers

import (
	"fmt"
	"github.com/gin-gonic/gin"
)

func GetUsers(c *gin.Context) {
	fmt.Printf("Users got")
}

func CreateUser(c *gin.Context) {
	fmt.Printf("User created")
}
