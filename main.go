package main

import (
	"api-gorails/conf"
	"api-gorails/dao"
	"fmt"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
	"os"
	"path"
	"strings"
	"text/template"
)

// 普通模板实体
type TemplateEntity struct {
	conf.ProgramConfig
	Columns      []dao.Column
	ClassName    string
	TableName    string
	TableComment string
	Imports      []string
}

// Beego路由模板实体
type RouterTemplateEntity struct {
	conf.ProgramConfig
	Tables []dao.Table
}

func main() {

	if len(os.Args) == 1 || isExistOption("help") {
		printWelcome()
	}

	if isExistOption("new") {
		generateInit()
	}

	if isExistOption("update") {
		dataSource := conf.DB.User + ":" + conf.DB.Password + "@tcp(" + conf.DB.Host + ":" + conf.DB.Port + ")/" + conf.DB.Name + "?charset=utf8"
		orm.RegisterDriver("mysql", orm.DRMySQL)
		orm.RegisterDataBase("default", "mysql", dataSource)
		generateUpdate()
	}
}

// 是否存在指令
func isExistOption(s string) bool {
	for _, v := range os.Args {
		if v == s {
			return true
		}
	}
	return false
}

// 打印欢迎信息
func printWelcome() {
	fmt.Println("api-gorails生成工具V1.0")
	fmt.Println("Options:")
	fmt.Println("\tnew\t初始化,例如: api-gorails new dirname -db.name=db -db.host=localhost -db.port=3306 -db.user=user -db.password=password")
	fmt.Println("\tupdate\t更新,例如：api-gorails update")
	fmt.Println("\thelp\t查看帮助")
}

// 初始化
func generateInit() {
	var dbName string
	var dbHost string
	var dbPort string
	var dbUser string
	var dbPassword string
	programName := os.Args[2]

	for _, v := range os.Args {
		if strings.HasPrefix(v, "-") {
			v2 := strings.Split(v, "=")
			if strings.Contains(v, "-db.name") {
				dbName = v2[1]
			}
			if strings.Contains(v, "-db.host") {
				dbHost = v2[1]
			}
			if strings.Contains(v, "-db.port") {
				dbPort = v2[1]
			}
			if strings.Contains(v, "-db.user") {
				dbUser = v2[1]
			}
			if strings.Contains(v, "-db.password") {
				dbPassword = v2[1]
			}
		}
	}

	if programName == "" || dbName == "" || dbHost == "" || dbPort == "" || dbUser == "" {
		panic("缺少参数")
		return
	}

	mkdir(programName)

	tmpl, err := template.New("test").Parse(`{
	  "db.name":"` + dbName + `",
	  "db.port":"` + dbPort + `",
	  "db.host":"` + dbHost + `",
	  "db.user":"` + dbUser + `",
	  "db.password":"` + dbPassword + `",

	  "generate.do.package":"do",
	  "generate.dao.package":"dao",
	  "generate.condition.package":"condition",
	  "generate.service.package":"service",
	  "generate.controller.package":"controllers",
	  "generate.router.package":"routers",
	  "generate.generatedir":"",
	  "generate.name":"` + programName + `"
	}`)

	if err != nil {
		panic(err)
	}
	filename := path.Join(programName, "generate_config.json")
	if exist, _ := pathExists(filename); !exist {
		file, _ := os.Create(filename)
		defer file.Close()
		tmpl.Execute(file, nil)
	}
}

// 生成
func generateUpdate() {
	// 取出所有的表
	tables := dao.ListTable(conf.DB.Name)
	for i := 0; i < len(tables); i++ {
		tables[i].ClassName = convertToPropertyFormat(tables[i].Name)
	}
	
	router := RouterTemplateEntity{conf.Program, tables}

	// 遍历表，生成do、dao、condition、service、controller等文件
	for _, table := range tables {
		entity := TemplateEntity{ProgramConfig: conf.Program}
		columns, err := dao.ListColumn(table.Name, conf.DB.Name)
		if err != nil {
			logs.Error(err)
			return
		}
		for i := 0; i < len(columns); i++ {
			columns[i].EntityPropertyName = convertToPropertyFormat(columns[i].Name)
			columns[i].EntityPropertyType = convertToPropertyType(columns[i].DataType)
			columns[i].EntityPropertyWapperType = convertToPropertyWapperType(columns[i].DataType)
			columns[i].FormPropertyName = convertFirstWordLower(columns[i].EntityPropertyName)
			if isTimeColumn(columns[i].DataType) {
				if columns[i].Name == "insert_time" {
					columns[i].OrmTimeDesc = ";auto_now_add;type(datetime)"
				}
				if columns[i].Name == "update_time" {
					columns[i].OrmTimeDesc = ";auto_now;type(datetime)"
				}
			}
		}
		entity.Columns = columns
		entity.TableName = table.Name
		entity.ClassName = convertToPropertyFormat(table.Name)
		entity.TableComment = table.Comment

		// 判断是否有日期类型，有的话增加time包的导入
		if isTableHasTimeColumn(columns) {
			entity.Imports = append(entity.Imports, conf.Program.ProgramName+"/util")
		}

		// 生成Do文件
		createFileCore("entity.tpl", entity.DoPackage, entity.TableName, entity, "generate", true, true)
		createFileCore("entity_ext.tpl", entity.DoPackage, entity.TableName, entity, "", true, false)

		// 生成Codition文件
		createFileCore("condition_types.tpl", entity.ConditionPackage, "types", conf.Program, "generate", true, true)
		createFileCore("condition_base.tpl", entity.ConditionPackage, "base", conf.Program, "generate", true, true)
		createFileCore("condition.tpl", entity.ConditionPackage, entity.TableName, entity, "generate", true, true)
		createFileCore("condition_ext.tpl", entity.ConditionPackage, entity.TableName, entity, "", true, false)

		// 生成Dao文件
		createFileCore("dao_base.tpl", entity.DaoPackage, "base", router, "generate", true, true)
		createFileCore("dao.tpl", entity.DaoPackage, entity.TableName, entity, "generate", true, true)
		createFileCore("dao_ext.tpl", entity.DaoPackage, entity.TableName, entity, "", true, false)

		// 创建Service文件
		createFileCore("service_base.tpl", entity.ServicePackage, "base", conf.Program, "", true, false)
		createFileCore("service.tpl", entity.ServicePackage, entity.TableName, entity, "", true, false)

		// 创建Controller文件
		if !hasImpotedUtilPackage(entity.Imports) {
			entity.Imports = append(entity.Imports, conf.Program.ProgramName+"/util")
		}
		createFileCore("controller_base.tpl", entity.ControllerPackage, "base", conf.Program, "", true, false)
		createFileCore("controller.tpl", entity.ControllerPackage, entity.TableName, entity, "", true, false)
	}
	createFileCore("main.tpl", "", "main.go", router, "", false, false)
	createFileCore("router.tpl", conf.Program.RouterPackage, "router.go", router, "", false, false)
	createFileCore("glide.tpl", "", "glide.yaml", conf.Program, "", false, false)
	createFileCore("config.tpl", "conf", "config.go", nil, "", false, false)
	createFileCore("config_json.tpl", "conf", "config.json", conf.DB, "", false, false)
	createFileCore("app_conf.tpl", "conf", "app.conf", conf.Program, "", false, false)
	createFileCore("readme.tpl", "", "readme.md", nil, "", false, false)
	createFileCore("util_json_time.tpl", "util", "json_time", nil, "", true, false)
	createFileCore("util_convert_interface.tpl", "util", "convert", nil, "", true, false)
	mkdir(path.Join(conf.Program.GenerateDir, "logs"))
}

// 创建文件名称
func createFileName(pkg string, ext string, tableName string) string {
	res := ""
	if pkg != "" {
		res += pkg + "_"
	}
	if ext != "" {
		res += ext + "_"
	}
	if tableName != "" {
		res += tableName
	}
	return res + ".go"
}

// 创建文件核心功能
func createFileCore(templateName string, packageName string, filename string, data interface{}, ext string, isSpecialFileName bool, isCanOverride bool) {
	templateData, _ := Asset("template/" + templateName)
	tpl, err := template.New("test").Parse(string(templateData))
	if err != nil {
		logs.Error(err)
		return
	}
	dir := path.Join(conf.Program.GenerateDir, packageName)
	mkdir(dir)
	if isSpecialFileName {
		filename = createFileName(ext, packageName, filename)
	}
	filename = path.Join(dir, filename)
	exist, _ := pathExists(filename)
	// 能覆盖 || 不存在
	if isCanOverride || !exist {
		file, _ := os.Create(filename)
		defer file.Close()
		tpl.Execute(file, data)
	}
}

// 表字段转驼峰格式
func convertToPropertyFormat(value string) string {
	arr := strings.Split(value, "_")
	res := ""
	for _, v := range arr {
		res += convertFirstWordUpper(v)
	}
	return res
}

// 首字母大写
func convertFirstWordUpper(s string) string {
	res := ""
	for i, v := range s {
		if i == 0 {
			res += strings.ToUpper(string(v))
		} else {
			res += string(v)
		}
	}
	return res
}

// 首字母小写
func convertFirstWordLower(s string) string {
	res := ""
	for i, v := range s {
		if i == 0 {
			res += strings.ToLower(string(v))
		} else {
			res += string(v)
		}
	}
	return res
}

// 表字段类型转实体的属性类型
func convertToPropertyType(value string) string {
	switch value {
	case "varchar":
		return "string"
	case "blob":
		return "string"
	case "int":
		return "int"
	case "timestamp":
		return "util.JsonTime"
	case "datetime":
		return "util.JsonTime"
	case "decimal":
		return "float64"
	default:
		return ""
	}
}

// 表字段类型转实体包装类类型
func convertToPropertyWapperType(value string) string {
	switch value {
	case "varchar":
		return "String"
	case "blob":
		return "String"
	case "int":
		return "Integer"
	case "timestamp":
		return "Date"
	case "datetime":
		return "Date"
	case "decimal":
		return "Double"
	default:
		return ""
	}
}

// 生成目录
func mkdir(dir string) {
	if ok, _ := pathExists(dir); !ok {
		os.Mkdir(dir, os.ModePerm)
	}
}

// 路径是否存在
func pathExists(path string) (bool, error) {
	_, err := os.Stat(path)
	if err == nil {
		return true, nil
	}
	if os.IsNotExist(err) {
		return false, nil
	}
	return false, err
}

// 表字段中是否包含日期类型
func isTableHasTimeColumn(arr []dao.Column) bool {
	for _, v := range arr {
		if isTimeColumn(v.DataType) {
			return true
		}
	}
	return false
}

func isTimeColumn(s string) bool {
	return s == "timestamp" || s == "datetime"
}

func hasImpotedUtilPackage(arr []string) bool {
	for _, v := range arr {
		if strings.Contains(v, "util") {
			return true
		}
	}
	return false
}
