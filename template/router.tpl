// @APIVersion 1.0.0
// @Title {{.ProgramName}} API
// @Description {{.ProgramName}} API
package {{.RouterPackage}}

import (
	"github.com/astaxie/beego"
	"{{.ProgramName}}/{{.ControllerPackage}}"
)
{{ $controller:=.ControllerPackage}}
func init() {
	ns := beego.NewNamespace("/api",
		{{range $e := .Tables}}
        beego.NSNamespace("/{{$e.Name}}",
            beego.NSInclude(
                &{{$controller}}.{{$e.ClassName}}Controller{},
            ),
        ),
        {{end}}
    )
    beego.AddNamespace(ns)
}
