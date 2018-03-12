package {{.ControllerPackage}}

import (
	. "{{.ProgramName}}/{{.ConditionPackage}}"
	. "{{.ProgramName}}/{{.ServicePackage}}"    
)
{{$DoPackage:=.DoPackage}}
type {{.ClassName}}Controller struct {
	BaseController
}

// @Title 返回列表
// @Description 返回列表
{{range .Columns}}// @Param {{.Name}} query {{.EntityPropertyType}} false "{{.Comment}}"
{{end}}// @Param page query int false "当前页，默认1"
// @Param rows query int false "每页条数，默认10"
// @Param order_by query string false "排序条件"
// @Success 200 {object} {{$DoPackage}}.{{.ClassName}} 数组
// @router /list [get]
func (x *{{.ClassName}}Controller) List() {
	cond := x.getCond()
	dt, err := x.getService().List(cond)
	x.handlerError(err)
	x.getSuccessResponse(dt)
}

// @Title 返回一条
// @Description 返回一条
{{range .Columns}}// @Param {{.Name}} query {{.EntityPropertyType}} false "{{.Comment}}"
{{end}}// @Success 200 {object} {{$DoPackage}}.{{.ClassName}} 对象
// @router /get [get]
func (x *{{.ClassName}}Controller) Get() {
	cond := x.getCond()
	dt, err := x.getService().GetByCond(cond)
	x.handlerError(err)
	x.getSuccessResponse(dt)
}

// @Title 新增记录
// @Description 新增记录
{{range .Columns}}// @Param {{.Name}} query {{.EntityPropertyType}} false "{{.Comment}}"
{{end}}// @Success 200
// @router /insert [post]
func (x *{{.ClassName}}Controller) Insert() {
	cond := x.getCond()	
	e := cond.To{{.ClassName}}()
	_, err := x.getService().Insert(e)
	x.handlerError(err)
	x.getSuccessResponse(nil)
}

// @Title 更新记录
// @Description 更新记录
{{range .Columns}}// @Param {{.Name}} query {{.EntityPropertyType}} false "{{.Comment}}"
{{end}}// @Success 200
// @router /update [post]
func (x *{{.ClassName}}Controller) Update() {
	cond := x.getCond()
	e := cond.To{{.ClassName}}()
	err := x.getService().Update(e)
	x.handlerError(err)
	x.getSuccessResponse(nil)
}

// @Title 删除记录
// @Description 删除记录
{{range .Columns}}// @Param {{.Name}} query {{.EntityPropertyType}} false "{{.Comment}}"
{{end}}// @Success 200
// @router /delete [post]
func (x *{{.ClassName}}Controller) Delete() {
	cond := x.getCond()
	err := x.getService().Delete(cond)
	x.handlerError(err)
	x.getSuccessResponse(nil)
}

func (x *{{.ClassName}}Controller) getService() *{{.ClassName}}Service {
	return new({{.ClassName}}Service).Register()
}

func (x *{{.ClassName}}Controller) getCond() {{.ClassName}}Cond {
	params := {{.ClassName}}Cond{}
	err := x.ParseForm(&params)
	x.handlerError(err)
	return params
}