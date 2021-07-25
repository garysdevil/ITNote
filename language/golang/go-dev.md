## Go插件
1. 代码质量检查
    ```bash
    golint .\main.go
    ```

2. 代码提示
    - 参考 https://mp.weixin.qq.com/s?__biz=MzAxNzY0NDE3NA==&mid=2247484866&idx=1&sn=6872f1d6dc1064a39a7772166bea7790&chksm=9be32a23ac94a3350b1d2a721469371fc4d7d162c667feb9344b7a9531d86e1d139769a72a2a&scene=27#wechat_redirect
    - gopls  2021年

3. 文档 godoc
    ```bash
    # godoc
    go get -v -u golang.org/x/tools/cmd/godo
    # 生成本地文档服务器
    godoc -http=:6060
    ```
## CLI操作
### go编译
```bash
# 1. 编译当前目录并输出指定可执行文件
go build -o 输出指定文件

# 2. 编译运行
go run .

# 3. 精简编译
go build -ldflags "-s -w"
-s 相当于strip掉符号表
-w 告知连接器放弃所有debug信息

# 4. 编译时使用vendor中的依赖
go build -mod vendor
```
### gofmt
- 官方提供的代码格式化工具
```bash
# -w 直接将结果输出到源文件
# -l 列出被格式化的文件
# -s 开启简化代码功能

# 格式化单文件
gofmt -l -w  test.go

# 格式化整个工程
gofmt -l -w ./
```