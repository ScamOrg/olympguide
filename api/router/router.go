package router

import (
	"api/handler"
	"api/middleware"
	"api/utils/role"
	"fmt"
	"github.com/gin-contrib/sessions"
	"github.com/gin-gonic/gin"
	"log"
)

type Router struct {
	r        *gin.Engine
	handlers *handler.Handlers
	mw       *middleware.Mw
	store    *sessions.Store
}

func NewRouter(handlers *handler.Handlers, mw *middleware.Mw, store *sessions.Store) *Router {
	return &Router{
		r:        gin.Default(),
		handlers: handlers,
		mw:       mw,
		store:    store,
	}
}

func (rt *Router) Run(port int) {
	rt.setupRoutes()

	serverAddress := fmt.Sprintf(":%d", port)
	log.Printf("Server listening on %s", serverAddress)
	if err := rt.r.Run(serverAddress); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}

func (rt *Router) setupRoutes() {
	rt.r.Use(sessions.Sessions("session", *rt.store))
	rt.r.Use(rt.mw.SessionMiddleware())
	rt.r.Use(rt.mw.ValidateID())

	rt.setupAuthRoutes()
	rt.setupUniverRoutes()
	rt.setupUserRoutes()
	rt.setupFieldRoutes()
	rt.setupOlympRoutes()
	rt.setupMetaRoutes()
	rt.setupFacultyRoutes()
	rt.setupProgramRoutes()
}

func (rt *Router) setupAuthRoutes() {
	authGroup := rt.r.Group("/auth")
	authGroup.POST("/send-code", rt.handlers.Auth.SendCode)
	authGroup.POST("/verify-code", rt.handlers.Auth.VerifyCode)
	authGroup.POST("/sign-up", rt.handlers.Auth.SignUp)
	authGroup.POST("/login", rt.handlers.Auth.Login)
	authGroup.POST("/logout", rt.handlers.Auth.Logout)
	authGroup.GET("/check-session", rt.handlers.Auth.CheckSession)
}

func (rt *Router) setupUniverRoutes() {
	rt.r.GET("/universities", rt.handlers.Univer.GetUnivers)
	university := rt.r.Group("/university")
	{
		university.POST("/", rt.mw.RolesMiddleware(role.Founder, role.Admin, role.DataLoaderService), rt.handlers.Univer.NewUniver)

		universityWithID := university.Group("/:id")
		{
			universityWithID.GET("/", rt.handlers.Univer.GetUniver)
			universityWithID.GET("/faculties", rt.handlers.Faculty.GetFaculties)
			universityWithID.GET("/programs/by-faculty", rt.handlers.Program.GetUniverProgramsWithFaculty)
			universityWithID.GET("/programs/by-field", rt.handlers.Program.GetUniverProgramsWithGroup)
		}

		universityWithID.Use(rt.mw.UniversityIdSetter(),
			rt.mw.RolesMiddleware(role.Founder, role.Admin, role.DataLoaderService, role.UniverEditor))
		{
			universityWithID.PUT("/", rt.handlers.Univer.UpdateUniver)
			universityWithID.DELETE("/", rt.handlers.Univer.DeleteUniver)
		}
	}
}

func (rt *Router) setupFieldRoutes() {
	rt.r.GET("/fields", rt.handlers.Field.GetGroups)
	rt.r.GET("/field/:id", rt.handlers.Field.GetField)
}

func (rt *Router) setupOlympRoutes() {
	rt.r.GET("/olympiads", rt.handlers.Olymp.GetOlympiads)
}

func (rt *Router) setupUserRoutes() {
	user := rt.r.Group("/user", rt.mw.UserMiddleware())
	{
		user.GET("/data", rt.handlers.User.GetUserData)
		favourite := user.Group("/favourite")
		{
			favourite.GET("/programs", rt.handlers.Program.GetLikedPrograms)
			favourite.POST("/program/:id", rt.handlers.Program.LikeProgram)
			favourite.DELETE("/program/:id", rt.handlers.Program.DislikeProgram)

			favourite.GET("/universities", rt.handlers.Univer.GetLikedUnivers)
			favourite.POST("/university/:id", rt.handlers.Univer.LikeUniver)
			favourite.DELETE("/university/:id", rt.handlers.Univer.DislikeUniver)

			favourite.GET("/olympiads", rt.handlers.Olymp.GetLikedOlympiads)
			favourite.POST("/olympiad/:id", rt.handlers.Olymp.LikeOlymp)
			favourite.DELETE("/olympiad/:id", rt.handlers.Olymp.DislikeOlymp)
		}
	}
}

func (rt *Router) setupMetaRoutes() {
	meta := rt.r.Group("/meta")
	meta.GET("/regions", rt.handlers.Meta.GetRegions)
	meta.GET("/university-regions", rt.handlers.Meta.GetUniversityRegions)
	meta.GET("/olympiad-profiles", rt.handlers.Meta.GetOlympiadProfiles)
	meta.GET("/subjects", rt.handlers.Meta.GetSubjects)
}

func (rt *Router) setupFacultyRoutes() {
	faculty := rt.r.Group("/faculty")
	faculty.Use(rt.mw.RolesMiddleware(role.Founder, role.Admin, role.DataLoaderService))
	{
		faculty.POST("/", rt.handlers.Faculty.NewFaculty)

		facultyWithID := faculty.Group("/:id")
		{
			facultyWithID.PUT("/", rt.handlers.Faculty.UpdateFaculty)
			facultyWithID.DELETE("/", rt.handlers.Faculty.DeleteFaculty)
			facultyWithID.GET("/programs", rt.mw.NoMiddleware(), rt.handlers.Program.GetProgramsByFaculty)
		}
	}
}

func (rt *Router) setupProgramRoutes() {
	program := rt.r.Group("/program")
	program.POST("/", rt.handlers.Program.NewProgram)
	{
		programWithID := program.Group("/:id")
		{
			programWithID.GET("/", rt.handlers.Program.GetProgram)
		}
	}
}
