## 介绍
> go.rails是一个基于beego的API快速开发框架，并且支持Swagger。

## 安装步骤
1. 首先确保安装了Glide(包管理器) 以及 资源文件打包工具
```
$ go get -u github.com/Masterminds/glide
$ go get -u github.com/jteeuwen/go-bindata
```
2. 安装及运行
```
$ glide update # 安装依赖包
$ go-bindata template/ # 将template打包进可执行文件
$ go run *.go init # 会生成generate目录，修改相关配置
$ go run *.go update # 生成代码
```