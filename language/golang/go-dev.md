## Go开发规范
1. 代码质量检查
 golint .\main.go

## CLI操作
1. 编译当前目录并输出指定可执行文件
go build -o 输出指定文件

2. 编译运行
go run .

3. 精简编译
go build -ldflags "-s -w"
-s 相当于strip掉符号表
-w 告知连接器放弃所有debug信息

