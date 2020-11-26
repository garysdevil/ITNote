## Go开发规范
1. 代码质量检查
 golint .\main.go

2. 代码提示
参考 https://mp.weixin.qq.com/s?__biz=MzAxNzY0NDE3NA==&mid=2247484866&idx=1&sn=6872f1d6dc1064a39a7772166bea7790&chksm=9be32a23ac94a3350b1d2a721469371fc4d7d162c667feb9344b7a9531d86e1d139769a72a2a&scene=27#wechat_redirect
gopls  2021年

3. 
## CLI操作
### go
1. 编译当前目录并输出指定可执行文件
go build -o 输出指定文件

2. 编译运行
go run .

3. 精简编译
go build -ldflags "-s -w"
-s 相当于strip掉符号表
-w 告知连接器放弃所有debug信息

### gofmt

### godoc
1. 生成本地文档服务器
godoc -http=:6060