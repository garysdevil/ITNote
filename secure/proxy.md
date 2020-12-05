## goproxy
- https://github.com/snail007/goproxy

### 安装使用
curl -L https://raw.githubusercontent.com/snail007/goproxy/master/install_auto.sh | bash
proxy socks -t tcp -p "0.0.0.0:38080"
--log proxy.log 
--daemon
--forever # 防止进程意外退出