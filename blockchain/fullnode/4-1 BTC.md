[TOC]
### 部署BTC
- 使用node进行安装部署
```shell
apt-get install libzmq3-dev build-essential 

useradd -m -r bitcoin

su - bitcoin

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

nvm install v8

npm install bitcore -g

rm  把子模块里的bitcore-lib都删除掉 
# 创建一个新的节点,会自动在家目录创建一个${name}文件夹
name=bitnode
path=/data/btcfullnode
bitcore create $name -d $path
cd $path
# 安装insight-api insight-ui模块，使BTC的块高可以直接通过接口进行调用
vim bitcore-node.json
{
  "network": "livenet",
  "port": 3001,
  "services": [
    "bitcoind",
    "insight-api",
    "insight-ui",
    "web"
  ],
  "servicesConfig": {
    "insight-api": {
      "disableRateLimiter": true
    },
    "bitcoind": {
      "spawn": {
        "datadir": "./data",
        "exec": "/home/bitcore/.nvm/versions/node/<version>/lib/node_modules/bitcore/node_modules/bitcore-node/bin/bitcoind"
      }
    }
  }
}
bitcore install insight-api insight-ui
# 创建后台启动脚本
vim startBtc.sh
#! /bin/bash
export PATH=$PATH:/home/bitcoin/.nvm/versions/node/v8.16.2/bin/
# version=6时设置下面变量，node会报错；version=8时，成功
export NODE_OPTIONS=--max_old_space_size=3145728
cd /home/bitcoin/btcnode
logPath=/data/logs/bitcore_`date +%Y%m%d%H%M%S`.log
bitcored > ${logPath} 2>&1

# 启动
bash startBtc.sh
```
### 运维须知
1. 默认端口  
    p2p: 8333  
    rpc: 8332
    bitcore: 3001  
    ZMQ: 28332

2. API获取块高  
    curl http://localhost:3001/insight-api/sync

3. 获取相关信息
    curl http://localhost:3001/insight-api/status?=getTxOutSetInfo
4. 区块链游览器
  https://tbtc.bitaps.com/
5. 免费的接口调用（封装过的）
  https://developer.bitaps.com/blockchain#Last_block