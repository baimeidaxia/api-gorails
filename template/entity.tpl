// 程序自动生成, 下次更新会覆盖，自定义代码不要再这里编写
// by go.rails
package {{.DoPackage}}

import (
	{{range .Imports}} "{{.}}"
{{end}})

// 描述：{{ .TableComment }}
type {{ .ClassName }} struct {
    {{range .Columns}}{{ .EntityPropertyName }} {{ .EntityPropertyType }} `orm:"column({{ .Name }}){{.OrmTimeDesc}}" form:"{{.Name}}" json:"{{.Name}}" description:"{{.Comment}}"` // {{ .Comment }}
{{end}}}

func (x *{{ .ClassName }}) TableName() string {
	return "{{ .TableName }}"
}