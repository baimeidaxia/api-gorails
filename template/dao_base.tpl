package {{.DaoPackage}}

import (
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
	_ "github.com/go-sql-driver/mysql"
	. "{{.ProgramName}}/{{.DoPackage}}"
	. "{{.ProgramName}}/conf"
)

func init() {
    dataSource := DataSource.User + ":" + DataSource.Password + "@tcp(" + DataSource.Host + ":" + DataSource.Port + ")/" + DataSource.Name + "?charset=utf8&loc=Asia%2FShanghai"
    orm.RegisterDriver("mysql", orm.DRMySQL)
    orm.RegisterDataBase("default", "mysql", dataSource)
	orm.Debug = false
	{{range .Tables}}orm.RegisterModel(new({{.ClassName}}))
	{{end}}
}

type BaseDao struct {
	db *orm.Ormer
}

func (x *BaseDao) beforeResiter(db *orm.Ormer) *BaseDao {
	x.db = db
	return x
}

func (x *BaseDao) GetDB() orm.Ormer {
	if x.db == nil {
		logs.Error("尚未初始化DB")
	}
	return *x.db
}
