package handler

type Handlers struct {
	Auth    *AuthHandler
	Univer  *UniverHandler
	Field   *FieldHandler
	Olymp   *OlympHandler
	Meta    *MetaHandler
	User    *UserHandler
	Faculty *FacultyHandler
	Program *ProgramHandler
	Diploma *DiplomaHandler
}
