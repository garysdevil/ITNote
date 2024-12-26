## Go安装
- https://golang.org/dl
- https://golang.google.cn/dl/

### linux安装
```bash
cd /opt
wget https://go.dev/dl/go1.23.4.linux-386.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.23.4.linux-386.tar.gz

# linux环境变量 # 中国大陆内环境加一条配置 export GOPROXY=https://goproxy.cn,direct
tee /etc/profile.d/golang.sh > /dev/null << 'EOF'
export GOROOT=/usr/local/go
export GOPATH=/usr/local/go/gopath
export PATH=$PATH:/usr/local/go/bin:/usr/local/go/gopath/bin
export GO111MODULE=auto
export GO15VENDOREXPERIMENT=1
EOF

source /etc/profile
go version
```

- GOROOT
    - 是 Go 的安装目录，存放 Go 的编译器、工具链和标准库。
    - 确保 GOROOT 指向你安装的 Go 版本的路径，特别是如果你可能在同一机器上使用多个 Go 版本。
- GOPATH
    - Go 的工作区路径，存储开发项目和依赖包。
    - Go 1.16 或更高版本时，GOPATH 可以选择不设置，因为 Go Module 模式下，项目目录可以独立于 GOPATH。
- PATH，添加 Go 的二进制文件路径：
    - /usr/local/go/bin：Go 编译器和工具链的可执行文件路径。
    - /usr/local/go/gopath/bin：Go 项目中安装的依赖包的可执行文件路径。
- GO111MODULE
    - Go 1.14 及以后的版本默认开启了 Go Module 模式。
    - auto：在有 go.mod 文件时启用模块模式，否则禁用。
- GO15VENDOREXPERIMENT
    - 允许在项目中使用 vendor 文件夹存储依赖包。
    - 对于 Go 1.5 和 1.6 有意义，但在 Go 1.7+ 后默认启用。

### windows安装
默认安装目录 C:\Go
默认go path目录 C:\Users\Administrator\go

### mac安装
```bash
brew install go

echo 'export GOPATH=/Users/gary/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN' >> ~/.zshrc
```
source ~/.zshrc
### 基于vscode的开发环境
- https://blog.csdn.net/snans/article/details/106939925
1. 安装插件Go
ctrl+shift+x 打开插件扩展列表
下载go插件

2. 配置代理
- https://goproxy.io/zh/docs/getting-started.html
    1. windows环境变量 GOPROXY=https://goproxy.io

3. 下载go tools
ctrl+shift+p 打开命令面板
搜索 Go:install/update Tools, 点击全选ok

4. 重启vscode

## Go指令
- 临时环境变量
- Go version >= 1.13，直接用go env -w 设置
```bash
go env -w GOPROXY=https://goproxy.io,direct # 或 go env -w GOPROXY=https://goproxy.cn
go env -w GO111MODULE=on

# 取消代理
#取消  goproxy 代理设置
go env -u GOPROXY
go env -w GOPROXY=direct
```

```bash
# 查看 GOPROXY 变量
go env | grep GOPROXY
go env | findstr GOPROXY # Windows环境
```