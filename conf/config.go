package conf

import (
	"encoding/json"
	ioutil "io/ioutil"
)

type DBConfig struct {
	Name     string `json:"db.name"`
	Port     string `json:"db.port"`
	Host     string `json:"db.host"`
	User     string `json:"db.user"`
	Password string `json:"db.password"`
}

type ProgramConfig struct {
	DoPackage         string `json:"generate.do.package"`
	DaoPackage        string `json:"generate.dao.package"`
	ConditionPackage  string `json:"generate.condition.package"`
	ServicePackage    string `json:"generate.service.package"`
	ControllerPackage string `json:"generate.controller.package"`
	RouterPackage     string `json:"generate.router.package"`
	ProgramName       string `json:"generate.name"` // 项目名
	GenerateDir       string `json:"generate.generatedir"`
}

var (
	DB      = DBConfig{}
	Program = ProgramConfig{}
)

func init() {
	data, _ := ioutil.ReadFile("generate_config.json")
	json.Unmarshal(data, &DB)
	json.Unmarshal(data, &Program)
}
