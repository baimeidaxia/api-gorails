## 安装步骤
1. 首先确保安装了Glide(包管理器)
```
$ go get github.com/Masterminds/glide
```
2. 在src下新建一个项目, 比如: example
3. 拷贝api-gorails可执行文件放到example目录下
```
$ api-gorails new dirname -db.name=db -db.host=localhost -db.port=3306 -db.user=user -db.password=password  # 初始化, 修改相应的配置
$ api-gorails update # 更新项目，会自动生成代码
$ glide update # 安装依赖包
$ bee run -gendoc=true -downdoc=true # 运行，第一次运行需要指定-downdoc=true，下载swagger文件。
```