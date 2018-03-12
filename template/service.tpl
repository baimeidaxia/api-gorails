package {{.ServicePackage}}

import (
	. "{{.ProgramName}}/{{.ConditionPackage}}"
	. "{{.ProgramName}}/{{.DaoPackage}}"
	. "{{.ProgramName}}/{{.DoPackage}}"
)

type {{ .ClassName }}Service struct {
	BaseService
	dao *{{ .ClassName }}Dao
}

func (x *{{ .ClassName }}Service) Register() *{{ .ClassName }}Service {
	x.beforeRegister()
	x.dao = new({{ .ClassName }}Dao).Register(&x.db)
	return x
}

func (x *{{ .ClassName }}Service) List(cond {{ .ClassName }}Cond) ([]{{ .ClassName }}, error) {
	return x.dao.List(cond)
}

func (x *{{ .ClassName }}Service) Get(id int) ({{ .ClassName }}, error) {
	return x.dao.Get(id)
}

func (x *{{ .ClassName }}Service) GetByCond(cond {{ .ClassName }}Cond) ({{ .ClassName }}, error) {
	return x.dao.GetByCond(cond)
}

func (x *{{ .ClassName }}Service) Insert(e {{ .ClassName }}) (int64, error) {
	return x.dao.Insert(e)
}

func (x *{{ .ClassName }}Service) Update(e {{ .ClassName }}) error {
	return x.dao.Update(e)
}

func (x *{{ .ClassName }}Service) Delete(cond {{ .ClassName }}Cond) error {
	return x.dao.Delete(cond)
}
