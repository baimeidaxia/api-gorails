package dao

import (
	"github.com/astaxie/beego/orm"
	_ "github.com/go-sql-driver/mysql"
)

func GetDB() orm.Ormer {
	o := orm.NewOrm()
	o.Using("default")
	return o
}

func ListColumn(tableName string, dbName string) ([]Column, error) {
	columns := []Column{}
	_, err := GetDB().Raw(
		`SELECT
					column_name,
					data_type,
					column_comment,
					column_key
				FROM information_schema.columns
				WHERE table_name=? and table_schema=?`, tableName, dbName).QueryRows(&columns)
	return columns, err
}

func ListTable(dbName string) []Table {
	arr := []Table{}
	GetDB().Raw(`
	        SELECT
				table_name,
				table_comment
			FROM
				information_schema.TABLES
			WHERE
				table_schema = ?
			AND table_type = 'base table';`, dbName).QueryRows(&arr)
	return arr
}
