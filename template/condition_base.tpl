// 程序自动生成, 下次更新会覆盖，自定义代码不要再这里编写
// by go.rails
package {{.ConditionPackage}}

type BaseCond struct {
	Page    int    `form:"page"`
	Rows    int    `form:"rows"`
	OrderBy String `form:"order_by"`
	TakeNum int
	SkipNum int
}

func (x *BaseCond) GetTakeNum() int {
	if 0 == x.Rows {
		return 10
	}
	return x.Rows
}

func (x *BaseCond) GetSkipNum() int {
	if 0 == x.Page || 0 == x.Rows {
		return 0
	}
	return (x.Page - 1) * x.Rows
}
