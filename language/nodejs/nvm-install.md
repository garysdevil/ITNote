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

2. npm设置源
npm set registry http://localhost:4873/
3. npm 指定源然后安装包  
npm i --registry=https://registry.npm.taobao.org 


## 源管理器
npm install -g nrm
nrm ls
nrm use taobao
nrm add 别名 源地址：添加源

## 私服verdaccio
- 参考
    - https://verdaccio.org/docs/en/installation
    - https://github.com/verdaccio/verdaccio
1. docker部署
```bash
V_PATH=/opt/verdaccio; docker run -d --name verdaccio \
  -p 4873:4873 \
  -v $V_PATH/conf:/verdaccio/conf \
  -v $V_PATH/storage:/verdaccio/storage \
  -v $V_PATH/plugins:/verdaccio/plugins \
  verdaccio/verdaccio:5.x-next
```
2. 添加用户
npm adduser --registry http://x.x.x.x:4873
npm who am i --registry http://x.x.x.x:4873
npm profile get --registry http://x.x.x.x:4873/
3. 发布私有包
npm init -f 
vi index.js
```js
var user ={
 name:"gary",
 site:"garys.top"
}
module.exports=user;
```
npm publish --registry http://x.x.x.x:4873
