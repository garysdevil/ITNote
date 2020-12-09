## 安装node版本管理器
### Linux安装nvm
https://github.com/nvm-sh/nvm#installation
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash  或者
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

source ~/.bashrc 或者
. ~/.bashrc

### Windows安装nvm-windows/
https://github.com/coreybutler/nvm-windows/releases


## 包管理器 npm
1. npm install的执行过程
    1. 发出npm install命令
    2. npm 向 registry 查询模块压缩包的网址
    3. 下载压缩包，存放在~/.npm(本地NPM缓存路径)目录
    4. 解压压缩包到当前项目的node_modules目录

1. npm 指定源然后安装包  
npm i --registry=https://registry.npm.taobao.org 


## 源管理器
npm install -g nrm
nrm ls
nrm use taobao
nrm add 别名 源地址：添加源