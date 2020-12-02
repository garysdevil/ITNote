## 安装node版本管理器
### Linux安装nvm
https://github.com/nvm-sh/nvm#installation
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash  或者
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

source ~/.bashrc 或者
. ~/.bashrc

### Windows安装nvm-windows/
https://github.com/coreybutler/nvm-windows/releases


## npm 指定源然后安装包
npm i --registry=https://registry.npm.taobao.org 

## 源管理器
npm install -g nrm
nrm ls
nrm use taobao
nrm add 别名 源地址：添加源