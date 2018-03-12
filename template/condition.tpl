// 程序自动生成, 下次更新会覆盖，自定义代码不要再这里编写
// by go.rails
package {{.ConditionPackage}}

import (
    . "{{.ProgramName}}/do"
    "{{.ProgramName}}/util"
)

// 描述：{{ .TableComment }}
type {{ .ClassName }}Cond struct {
    BaseCond
    {{range .Columns}}{{.EntityPropertyName}} {{ .EntityPropertyWapperType }} `form:"{{.Name}}" description:"{{.Comment}}"` // {{ .Comment }}
    {{end}}
}

// 描述：实体转换
func (x *{{.ClassName}}Cond) To{{.ClassName}}() {{.ClassName}} {
	e := {{.ClassName}}{}
    {{range .Columns}}
    if x.{{.EntityPropertyName}} != nil {
        {{if eq .EntityPropertyType "int" }}e.{{.EntityPropertyName}} = util.ConvertInt(x.{{.EntityPropertyName}})
        {{else if eq .EntityPropertyType "util.JsonTime"}}e.{{.EntityPropertyName}} = util.ConvertJsonTime(x.{{.EntityPropertyName}})
        {{else if eq .EntityPropertyType "float64"}}e.{{.EntityPropertyName}} = x.{{.EntityPropertyName}}.(float64)
        {{else}}e.{{.EntityPropertyName}} = x.{{.EntityPropertyName}}.(string)
{{end}}}
    {{end}}
	return e
}