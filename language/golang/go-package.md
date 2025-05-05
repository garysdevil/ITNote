---
created_date: 2020-11-16
---

[TOC]

# 包 Package
## 包管理 go.mod
- 参考 https://blog.csdn.net/weixin_39003229/article/details/97638573

- go.mod 是Golang1.11版本新引入的官方包管理工具, 用于解决之前没有地方记录依赖包具体版本的问题。
	1. GO111MODULE=off，go命令行将不会支持module功能，寻找依赖包的方式将会沿用旧版本那种通过vendor目录或者GOPATH模式来查找。
	2. GO111MODULE=on，go命令行会使用modules，而一点也不会去GOPATH目录下查找。
	3. GO111MODULE=auto，默认值，go命令行将会根据当前目录来决定是否启用module功能。

- 依赖的第三方包存储位置
    - go.mod  $GOPATH/pkg/mod/
    - 传统的  $GOPATH/src

- go mod 指令
```bash
# 初始化modules
go mod init 自定义项目名
# 下载依赖包
go mod download 包全名
# 打印模块依赖图
go mod graph
# 验证依赖是否正确
go mod verify
# 拉取缺少的模块 和 移除不用的模块
go mod tidy
# 将依赖复制到vendor目录下
go mod vendor
# 解释为什么需要依赖
go mod why
# 改变go.mod里包的引用
go mod edit -replace example.com/greetings=../greetings
```



## 依赖包的import方式
- https://blog.csdn.net/stpeace/article/details/82901633
```go

import "fmt" 
import . "fmt" // 带点后， 在调用函数时可以省略包名
import _ "fmt" // 只调用fmt的init函数，禁止使用fmt包中的变量和函数
import F "fmt" // 设置fmt包的别名为F
```

## 内置包
1. fmt
	```go
	fmt.Printf("%+v\n", anyType)
	```

2. errors
	```go
	errors.New("defined error")
	```
3. log
```go
	log.SetPrefix("main: ")
	// log.SetFlags(0)
	log.Println("mylog")
```

4. time
	```go
	// 获取时间戳
	time.Now().UnixNano()

	// 生成随机数
	rand.Seed(time.Now().UnixNano()) // "math/rand"
	fmt.Println(rand.Intn(100))
	```

5. test 
	```bash
	# 参考 https://appliedgo.net/testmain/
	# 注意：当module名字为main时，在根目录下执行go test则会报错 /var/folders/8h/1m7cpf3935z6tgyxtqm7805h0000gn/T/go-build3557744028/b001/_testmain.go:13:2: cannot import "main"
	# 注意：一次只能单元测试一个目录内的文件,执行 go test -v ./*/*.go 则会报错 named files must all be in one directory;
	go test // go test ./
	# 默认会对当前目录内 文件名字为 *_test.go 的文件，名字以 Test开头的函数进行单元测试。
	```
	```go
	func Test_gary(t *testing.T) {
		name := "Gary"
		want := regexp.MustCompile(`\b` + name + `\b`)
		msg := "Gary" 
		if !want.MatchString(msg) {
			t.Fatalf("msg string must contain %v", name)
		}
	}
	```




1. encoding/json  
```go
data, _ := json.Marshal(变量)
fmt.Println(string(data))
// 
fmt.Printf("%v", &变量)
// 结构化输出
data, _ := json.Marshal(变量)
var out bytes.Buffer
json.Indent(&out, data, "", "\t")
fmt.Println(&out)
    
```


3. crypto
https://golang.org/pkg/crypto/cipher/#example_NewCFBEncrypter


4. reflect
