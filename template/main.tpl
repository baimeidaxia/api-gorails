package main

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
    "strconv"
	_ "{{.ProgramName}}/{{.RouterPackage}}"
	. "{{.ProgramName}}/conf"
)

func main() {
	if beego.BConfig.RunMode == "dev" {
		beego.BConfig.WebConfig.DirectoryIndex = true
		beego.BConfig.WebConfig.StaticDir["/swagger"] = "swagger"
	}

    logs.SetLogger(LogsConf.Adapter, `{"filename":"`+LogsConf.AdapterFileDir+"/"+LogsConf.AdapterFileName+`",
                                                "level":`+strconv.Itoa(LogsConf.Level)+`,
                                                "maxlines":`+strconv.Itoa(LogsConf.AdapterFileMaxlines)+`,
                                                "maxsize":`+strconv.Itoa(LogsConf.AdapterFileMaxsize)+`,
                                                "daily":`+LogsConf.AdapterFileDaily+`,
                                                "maxdays":`+strconv.Itoa(LogsConf.AdapterFileMaxdays)+`}`)
    if LogsConf.EnableAsync {
        logs.Async()
    }
	beego.Run()
}
