## 安装
- https://golang.org/dl
- https://golang.google.cn/dl/

- Go version >= 1.11，并且 GO111MODULE=on (Go MOdule 模式)
### linux安装
```bash
cd /opt
curl -O https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz 

tar -zvxf go1.12.7.linux-amd64.tar.gz
# linux环境变量
vi /etc/profile.d/golang
export GOROOT=/opt/go # go文件夹。    /opt/go/bin  go命令所在的bin目录
export GOPATH=/opt/go/space  # 存放第三方依赖的源码文件夹。   /opt/go/space/bin 编译后二进制文件的存放目的地和import包的搜索路径（默认为当前目录下）。

export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

source /etc/profile/golang
```

### windows安装
默认安装目录 C:\Go
默认go path目录 C:\Users\Administrator\go

### 基于vscode的开发
- https://blog.csdn.net/snans/article/details/106939925
1. 安装插件Go
ctrl+shift+x 打开插件扩展列表
下载go插件

2. 配置代理
- https://goproxy.io/zh/docs/getting-started.html
    1. windows环境变量 GOPROXY=https://goproxy.io”

3. 下载go tools
ctrl+shift+p 打开命令面板
搜索 Go:install/update Tools, 点击全选ok

4. 重启vscode
