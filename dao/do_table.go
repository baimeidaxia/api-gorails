package dao

// 描述：表字段结构体
type Column struct {
	Name                     string `orm:"column(column_name)"`    // 字段名
	DataType                 string `orm:"column(data_type)"`      // 数据类型
	Comment                  string `orm:"column(column_comment)"` // 注释
	Key                      string `orm:"column(column_key)"`     // 键类型
	EntityPropertyName       string // 类属性名
	EntityPropertyType       string // 类属性类型
	EntityPropertyWapperType string // 类属性包装类名
	FormPropertyName         string // 类属性表单名
	OrmTimeDesc              string //
}

type Table struct {
	Name      string `orm:"column(table_name)"`
	Comment   string `orm:"column(table_comment)"`
	ClassName string
}
