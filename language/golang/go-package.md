# 包 Package
## 包管理 go.mod
- 参考 https://blog.csdn.net/weixin_39003229/article/details/97638573

- go.mod 是Golang1.11版本新引入的官方包管理工具, 用于解决之前没有地方记录依赖包具体版本的问题。
	1. GO111MODULE=off，go命令行将不会支持module功能，寻找依赖包的方式将会沿用旧版本那种通过vendor目录或者GOPATH模式来查找。
	2. GO111MODULE=on，go命令行会使用modules，而一点也不会去GOPATH目录下查找。
	3. GO111MODULE=auto，默认值，go命令行将会根据当前目录来决定是否启用module功能。

1. 初始化modules
    go mod init 自定义项目名

2. 依赖的第三方包存储位置
    - go.mod  $GOPATH/pkg/mod/
    - 传统的  $GOPATH/src
## go的各种import方式
- https://blog.csdn.net/stpeace/article/details/82901633
```go

import "fmt" 
import . "fmt"
import _ "fmt"
import x "fmt"
```

## 内置包
1. encoding/json  
```go
data, _ := json.Marshal(结构体对象)
fmt.Println(string(data))
// 结构化输出
data, _ := json.Marshal(结构体对象)
var out bytes.Buffer
json.Indent(&out, data, "", "\t")
fmt.Printf("array=%v\n", out.String())
```
2. fmt
```go
fmt.Printf("%+v\n", anyType)
```
3. crypto
https://golang.org/pkg/crypto/cipher/#example_NewCFBEncrypter


4. reflect
