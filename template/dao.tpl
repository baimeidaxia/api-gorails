package {{.DaoPackage}}

import (
	"github.com/astaxie/beego/orm"
	"strings"

	. "{{.ProgramName}}/{{.ConditionPackage}}"
	. "{{.ProgramName}}/{{.DoPackage}}"
)

type {{.ClassName}}Dao struct {
	BaseDao
}

func (x *{{.ClassName}}Dao) Register(db *orm.Ormer) *{{.ClassName}}Dao {
	x.beforeResiter(db)
	return x
}

// 描述：返回列表
func (x *{{.ClassName}}Dao) List(cond {{.ClassName}}Cond) ([]{{.ClassName}}, error) {
	var list []{{.ClassName}}
	qs := x.GetDB().QueryTable("{{.TableName}}")
	qs = x.bindDefaultQueryFiter(cond, qs)
	_, err := qs.All(&list)
	return list, err
}

// 描述：新增接口
func (x *{{.ClassName}}Dao) Insert(entity {{.ClassName}}) (int64, error) {
	id, err := x.GetDB().Insert(&entity)
	return id, err
}

// 描述：更新接口
func (x *{{.ClassName}}Dao) Update(entity {{.ClassName}}) error {
	_, err := x.GetDB().Update(&entity)
	return err
}

// 描述：返回一条记录
func (x *{{.ClassName}}Dao) Get(id int) ({{.ClassName}}, error) {
	entity := {{.ClassName}}{Id: id}
	err := x.GetDB().Read(&entity)
	return entity, err
}

// 描述：根据查询条件,返回一个记录
func (x *{{.ClassName}}Dao) GetByCond(cond {{.ClassName}}Cond) ({{.ClassName}}, error) {
	list := []{{.ClassName}}{}
	qs := x.GetDB().QueryTable("{{.TableName}}")
	qs = x.bindDefaultQueryFiter(cond, qs)
    _, err := qs.All(&list)
	if len(list) == 0 {
		return {{.ClassName}}{}, err
	}
	return list[0], err
}

// 描述：删除一条记录
func (x *{{.ClassName}}Dao) Delete(cond {{.ClassName}}Cond) error {
	_, err := x.GetDB().Delete(x)
	return err
}

// 描述：绑定默认的查询条件
func (x *{{.ClassName}}Dao) bindDefaultQueryFiter(cond {{.ClassName}}Cond, qs orm.QuerySeter) orm.QuerySeter {
    {{range .Columns}}
    if cond.{{.EntityPropertyName}} != nil {
        {{if eq .EntityPropertyWapperType "String"}} qs = qs.Filter("{{.Name}}__contains", cond.{{.EntityPropertyName}}) {{else}} qs = qs.Filter("{{.Name}}", cond.{{.EntityPropertyName}}) {{end}}
    }
    {{end}}
	if cond.OrderBy != nil {
		arr := strings.Split(cond.OrderBy.(string), ",")
		if len(arr) > 0 {
			orderByArr := []string{}
			for i := 0; i < len(arr); i++ {
				brr := strings.Split(arr[i], " ")
				tag := ""
				if len(brr) > 0 && brr[1] == "desc" {
					tag = "-"
				}
				orderByArr = append(orderByArr, tag+brr[0])
			}
			qs = qs.OrderBy(orderByArr...)
		}
	}

	qs = qs.Limit(cond.GetTakeNum(), cond.GetSkipNum())
	return qs
}
