package {{.ControllerPackage}}

import (
	"github.com/astaxie/beego"
)

type BaseController struct {
	beego.Controller
}

type JsonResponse struct {
	Success bool        `json:"success"`
	Code    int         `json:"code"`
	Msg     string      `json:"msg"`
	Body    interface{} `json:"body"`
}


func (x *BaseController) getFailResponse(err error) {
	x.getResponse(JsonResponse{Success: false, Msg: err.Error()})
}

func (x *BaseController) getSuccessResponse(body interface{}) {
	x.getResponse(JsonResponse{Success: true, Body: body})
}

func (x *BaseController) getResponse(resp JsonResponse){
	x.Data["json"] = resp
	x.Ctx.Output.Header("Access-Control-Allow-Origin", "*")
	x.Ctx.Output.Header("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE")
	x.Ctx.Output.Header("Access-Control-Max-Age", "3600")
	x.Ctx.Output.Header("Access-Control-Allow-Headers", "x-requested-with")
	x.ServeJSON()
}

func (x *BaseController) handlerError(err error) {
	if err != nil {
		x.getFailResponse(err)
	}
}