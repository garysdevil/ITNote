## 安装node版本管理器 nvm
### Linux安装nvm
```bash
# https://github.com/nvm-sh/nvm#installation
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | sh

source ~/.bashrc 或者
. ~/.bashrc
```

```bash
# 中国大陆无法正常连接github的安装方式
export NVM_SOURCE=https://gitlab.com/mirrorx/nvm.git
curl -o- https://gitlab.com/mirrorx/nvm/-/raw/master/install.sh | bash
```

### Windows安装nvm-windows/
https://github.com/coreybutler/nvm-windows/releases

### Mac安装nvm
```bash
# https://github.com/nvm-sh/nvm#installation
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.39.5/install.sh | bash

# 手动设置环境变量 ~/.bashrc 或 ~/.bash_profile 或 ~/.zprofile 或 ~/.zshrc 或 ~/.profile
echo 'export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.zshrc
```

### 使用nvm
```bash 
nvm install stable ## 安装最新稳定版 node

nvm alias default lts/gallium # 指定node的默认版本
```

## 软件包源
```
npm --- https://registry.npmjs.org/

cnpm --- https://r.cnpmjs.org/

taobao --- https://registry.npm.taobao.org/

nj --- https://registry.nodejitsu.com/

rednpm --- https://registry.mirror.cqupt.edu.cn/

npmMirror --- https://skimdb.npmjs.com/registry/

deunpm --- http://registry.enpmjs.org/
```

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

3. 指令
```bash
# 查看全局安装过的包
npm list -g --depth 0

# npm 从5.2版开始，增加了 npx 命令
# npx 执行npm依赖包的二进制文件。
npx
```

## 包管理器 yarn
```bash
# 安装yarn
npm install yarn -g
# 替换为淘宝的源
yarn config set registry https://registry.npm.taobao.org/
```

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
