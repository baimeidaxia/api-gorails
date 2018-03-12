package conf

import (
	"encoding/json"
	"github.com/astaxie/beego/logs"
	ioutil "io/ioutil"
)

type DBConfig struct {
	Name     string `json:"db.name"`
	Port     string `json:"db.port"`
	Host     string `json:"db.host"`
	User     string `json:"db.user"`
	Password string `json:"db.password"`
}

type LogsConfig struct {
	AdapterFileDir      string `json:"logs.adapter.file.dir"`      // 文件保存目录
	AdapterFileName     string `json:"logs.adapter.file.name"`     // 文件名
	AdapterFileMaxlines int    `json:"logs.adapter.file.maxlines"` // 每个文件保存的最大行数，默认值 1000000
	AdapterFileMaxsize  int    `json:"logs.adapter.file.maxsize"`  // 每个文件保存的最大尺寸，默认值是 1 << 28, //256 MB
	AdapterFileDaily    string `json:"logs.adapter.file.daily"`    // 是否按照每天 logrotate，默认是 true
	AdapterFileMaxdays  int    `json:"logs.adapter.file.maxdays"`  // 文件最多保存多少天，默认保存 7 天
	Level               int    `json:"logs.level"`                 // 0:Emergency,1:Alert,2:Critical,3:Error,4:Warning,5:Notice,6:Info,7:Debug
	EnableAsync         bool   `json:"logs.eanble_async"`          // true启用，false不启用
	Adapter             string `json:"logs.adapter"`               // console,file,multifile,
}

var (
	DataSource = DBConfig{}
	LogsConf   = LogsConfig{}
)

func init() {
	data, err := ioutil.ReadFile("conf/config.json")
	if err != nil {
		logs.Error(err)
	}
	json.Unmarshal(data, &DataSource)
	json.Unmarshal(data, &LogsConf)
}
