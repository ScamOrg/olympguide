package router

import (
	"api/handler"
	"api/middleware"
	"api/utils/role"
	"github.com/gin-gonic/gin"
)

type Router struct {
	authHandler    *handler.AuthHandler
	univerHandler  *handler.UniverHandler
	fieldHandler   *handler.FieldHandler
	olympHandler   *handler.OlympHandler
	metaHandler    *handler.MetaHandler
	userHandler    *handler.UserHandler
	facultyHandler *handler.FacultyHandler
	programHandler *handler.ProgramHandler
	mw             *middleware.Mw
}

func NewRouter(auth *handler.AuthHandler, univer *handler.UniverHandler,
	field *handler.FieldHandler, olymp *handler.OlympHandler,
	meta *handler.MetaHandler, user *handler.UserHandler,
	faculty *handler.FacultyHandler, program *handler.ProgramHandler, mw *middleware.Mw) *Router {
	return &Router{
		authHandler:    auth,
		univerHandler:  univer,
		fieldHandler:   field,
		olympHandler:   olymp,
		metaHandler:    meta,
		userHandler:    user,
		facultyHandler: faculty,
		programHandler: program,
		mw:             mw,
	}
}

func (rt *Router) SetupRoutes(r *gin.Engine) {
	r.Use(rt.mw.SessionMiddleware())
	r.Use(rt.mw.ValidateID())

	rt.setupAuthRoutes(r)
	rt.setupUniverRoutes(r)
	rt.setupUserRoutes(r)
	rt.setupFieldRoutes(r)
	rt.setupOlympRoutes(r)
	rt.setupMetaRoutes(r)
	rt.setupFacultyRoutes(r)
}

func (rt *Router) setupAuthRoutes(r *gin.Engine) {
	authGroup := r.Group("/auth")
	authGroup.POST("/send-code", rt.authHandler.SendCode)
	authGroup.POST("/verify-code", rt.authHandler.VerifyCode)
	authGroup.POST("/sign-up", rt.authHandler.SignUp)
	authGroup.POST("/login", rt.authHandler.Login)
	authGroup.POST("/logout", rt.authHandler.Logout)
}

func (rt *Router) setupUniverRoutes(r *gin.Engine) {
	r.GET("/universities", rt.univerHandler.GetUnivers)
	university := r.Group("/university")
	{
		university.GET("/:id", rt.univerHandler.GetUniver)
		university.GET("/:id/faculties", rt.facultyHandler.GetFaculties)
		university.POST("/", rt.mw.RolesMiddleware(role.Founder, role.Admin, role.DataLoaderService), rt.univerHandler.NewUniver)

		universityWithID := university.Group("/:id", rt.mw.UniversityIdSetter())
		universityWithID.Use(rt.mw.RolesMiddleware(role.Founder, role.Admin, role.DataLoaderService, role.UniverEditor))
		{
			universityWithID.PUT("", rt.univerHandler.UpdateUniver)
			universityWithID.DELETE("", rt.univerHandler.DeleteUniver)
		}
	}
}

func (rt *Router) setupFieldRoutes(r *gin.Engine) {
	r.GET("/fields", rt.fieldHandler.GetGroups)
	r.GET("/field/:id", rt.fieldHandler.GetField)
}

func (rt *Router) setupOlympRoutes(r *gin.Engine) {
	r.GET("/olympiads", rt.olympHandler.GetOlympiads)
}

func (rt *Router) setupUserRoutes(r *gin.Engine) {
	user := r.Group("/user", rt.mw.UserMiddleware())
	{
		user.GET("/data", rt.userHandler.GetUserData)
		favourite := user.Group("/favourite")
		{
			favourite.GET("/universities", rt.univerHandler.GetLikedUnivers)
			favourite.POST("/university/:id", rt.univerHandler.LikeUniver)
			favourite.DELETE("/university/:id", rt.univerHandler.DislikeUniver)

			favourite.GET("/olympiads", rt.olympHandler.GetLikedOlympiads)
			favourite.POST("/olympiad/:id", rt.olympHandler.LikeOlymp)
			favourite.DELETE("/olympiad/:id", rt.olympHandler.DislikeOlymp)
		}
	}
}

func (rt *Router) setupMetaRoutes(r *gin.Engine) {
	meta := r.Group("/meta")
	meta.GET("/regions", rt.metaHandler.GetRegions)
	meta.GET("/university-regions", rt.metaHandler.GetUniversityRegions)
	meta.GET("/olympiad-profiles", rt.metaHandler.GetOlympiadProfiles)
}

func (rt *Router) setupFacultyRoutes(r *gin.Engine) {
	faculty := r.Group("/faculty")
	{
		faculty.POST("/", rt.facultyHandler.NewFaculty)

		facultyWithID := faculty.Group("/:id")
		{
			facultyWithID.PUT("", rt.facultyHandler.UpdateFaculty)
			facultyWithID.DELETE("", rt.facultyHandler.DeleteFaculty)
			facultyWithID.GET("/programs", rt.programHandler.GetProgramsByFaculty)
		}
	}
}
