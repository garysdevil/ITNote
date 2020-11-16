### 一 包管理
#### go.mod
- 参考 https://blog.csdn.net/weixin_39003229/article/details/97638573

- go.mod 是Golang1.11版本新引入的官方包管理工具, 用于解决之前没有地方记录依赖包具体版本的问题。

1. 初始化modules
    go mod init 包名

2. 依赖的第三方包存储位置
    - go.mod       $GOPATH/pkg/mod/
    - 传统的  $GOPATH/src

### 二 文档
#### swagger

#### go-swagger
1. 功能
    - 文档即注解
    - 文档即测试
2. windows下简单安装
```bash
# https://github.com/go-swagger/go-swagger/blob/master/docs/install.md
go clone github.com/go-swagger/go-swagger
cd go-swagger
go install ./cmd/swagger
# 生成规格文件
swagger generate spec -o ./swagger.json  

# 根据json文件生成swagger服务端代码
swagger generate server -f ./swagger.json

# 启动swagger服务
swagger serve -F=swagger ./swagger.yaml (文档格式必须是yaml)
swagger serve  ./swagger.yaml
```
#### go集成gin+swagger自动生成文档
- 参考 https://github.com/swaggo/gin-swagger
1. swag 用于生成 docs 文件夹(swagger文档程序使用)
    go get github.com/swaggo/swag/cmd/swag
    swag init

2. 集成进go代码里
    1. 下载 gin-swagger 
        go get github.com/swaggo/gin-swagger
        go get github.com/swaggo/files
    2. 示范
```go
package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
	_ "test/docs" // swagger docs文档的位置
)

func main() {
	r := gin.New()

	// 创建路由组
	v1 := r.Group("/api/v1")
	v1.GET("/sayHello/:name", sayHello)

	//url := ginSwagger.URL("http://localhost:8080/swagger/doc.json") // The url pointing to API definition
	r.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	r.Run()
}

// @你好世界
// @Description 你好
// @Accept  json
// @Produce json
// @Param   name     path    string     true        "name"
// @Success 200 {string} string	"name,helloWorld"
// @Router /api/v1/sayHello/{name} [get]
func sayHello(c *gin.Context) {
	name := c.Param("name")
	c.String(http.StatusOK, name+",helloWorld")
}
```

### 三 go的各种import方式
- https://blog.csdn.net/stpeace/article/details/82901633
```go

import "fmt" 
import . "fmt"
import _ "fmt"
import x "fmt"
```

### 内置包
1. encoding/json  
	data, _ := json.Marshal(结构体对象)
	fmt.Println(string(data))

### 四 常用的第三方包
1. 读取配置与热加载  github.com/spf13/viper  github.com/fsnotify/fsnotify
2. 数据库ORM github.com/jinzhu/gorm  github.com/go-sql-driver/mysql  gorm.io/gorm(v2 要求go1.14版本)
3. ldap认证 github.com/go-ldap/ldap/v3 学习文档https://godoc.org/gopkg.in/ldap.v3
4. web框架 github.com/gin-gonic/gin
5. Token github.com/dgrijalva/jwt-go
6. 文档 github.com/swaggo/gin-swagger  github.com/swaggo/files   github.com/swaggo/swag（生成doc）
7. 日志 github.com/sirupsen/logrus


#### gorm
- 关联查询
db.Model(&user).Association("company").Find(&company)

- 预加载
https://gorm.io/zh_CN/docs/preload.html
2. db.Preload 使用了子查询加载关联数据。
3. db.Joins 使用 inner join 加载关联数据。
3. 预加载全部 db.Preload(clause.Associations).Find(&users) 或者开启自动预加载 db.Set("gorm:auto_preload", true).Find(&users)

- 软删除硬删除
1. 查找所有包含deleted的 model.DB.Unscoped().Find(&api)
2. 删除所有的包含deleted的 model.DB.Unscoped().Delete(&API{})