## Go安装
- https://golang.org/dl
- https://golang.google.cn/dl/

### linux安装
```bash
cd /opt
wget https://golang.org/dl/go1.19.1.linux-amd64.tar.gz
wget https://go.dev/dl/go1.19.1.linux-amd64.tar.gz

tar -xzf go1.19.1.linux-amd64.tar.gz
# tar -C /usr/local -xzf go1.19.1.linux-amd64.tar.gz
# linux环境变量
vi /etc/profile.d/golang.sh
export GOROOT=/opt/go/bin # go命令所在的bin目录
export GOPATH=/opt/go/space  # 存放第三方依赖的源码文件夹。 编译后二进制文件的存放目的地和import包的搜索路径（默认为当前目录下）。

export PATH=$PATH:$GOROOT:$GOPATH

source /etc/profile
```

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
    go env -w GOPROXY=https://goproxy.io,direct
    go env -w GO111MODULE=on
    ```