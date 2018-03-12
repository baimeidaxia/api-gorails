package {{.ServicePackage}}

import "github.com/astaxie/beego/orm"

type BaseService struct {
	db orm.Ormer
}

func (x *BaseService) beforeRegister() {
	x.db = orm.NewOrm()
	x.db.Using("default")
}

func (x *BaseService) beginTran() error {
	return x.db.Begin()
}

func (x *BaseService) commitTran() error {
	return x.db.Commit()
}

func (x *BaseService) rollbackTran() error {
	return x.db.Rollback()
}
