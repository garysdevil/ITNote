1. Linux安装nvm
https://github.com/nvm-sh/nvm#installation
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
source ~/.bashrc

2. Windows安装nvm-windows/
https://github.com/coreybutler/nvm-windows/releases

2. 安装依赖
yum install -y gcc gcc-c++ make automake 

3. npm 安装报
npm i   --registry=https://registry.npm.taobao.org 

4. 源管理
npm install -g nrm
nrm ls
nrm use taobao
nrm add 别名 源地址：添加源