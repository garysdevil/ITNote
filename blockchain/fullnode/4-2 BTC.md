[TOC]
### 部署BTC
参考文档
https://github.com/bitpay/bitcore
https://blog.csdn.net/weixin_30613727/article/details/97989532

##### 环境需求：
1. testnet Requirements:
2核8G
磁盘150G
Trusted P2P Peer          ->  需要一个bitcoin全节点
MongoDB Server >= v3.4		->  需要MongoDB
node  v10
2. Requirements:
8核16G
磁盘1500G
io要达到10000
Trusted P2P Peer          ->  需要一个bitcoin全节点
MongoDB Server >= v3.4		->  需要MongoDB
node  v10
#### 安装
##### 1创建bitcore用户
```bash
useradd -m bitcore
chown -R bitcore.bitcore /data
su - bitcore
```
##### 2安装启动bitcoin
1. 下载最新的bitcoin全节点
    wget https://bitcoin.org/bin/bitcoin-core-0.19.1/bitcoin-0.19.1-x86_64-linux-gnu.tar.gz
    tar xzvf bitcoin-0.19.1-x86_64-linux-gnu.tar.gz && mv bitcoin-0.19.1 bitcoin && cd bitcoin
2. 编辑配置文件
mkdir /data/bitcoin
mkdir /home/bitcore/bitcoin/logs
vi bitcoin.conf
```conf
datadir=/data/bitcoin
testnet=1 # 主网则去掉这条配置
server=1
whitebind=127.0.0.1:18333
whitelist=127.0.0.1
txindex=1
addressindex=1 # 
timestampindex=1 # 
spentindex=1 #
zmqpubrawtx=tcp://127.0.0.1:28332
zmqpubhashtx=tcp://127.0.0.1:28333
zmqpubhashblock=tcp://127.0.0.1:28334
zmqpubrawblock=tcp://127.0.0.1:28335
rpcallowip=0.0.0.0/0
rpcport=18332
rpcuser=gary
rpcpassword=XXXXXX
uacomment=bitcore
```
3. 启动
```bash
# 配置文件要指定全路径
log=/home/bitcore/bitcoin/logs/`date '+%Y-%m-%d'`.log
/home/bitcore/bitcoin/bin/bitcoind  --rpcport=18332 --rpcbind=0.0.0.0 -conf=/home/bitcore/bitcoin/bitcoin.conf >> $log
```
##### 3安装MongoDB
版本 4+
##### 4安装node v10
node  v10
##### 5安装bitcore
1. 下载
git clone https://github.com/bitpay/bitcore
2. 安装依赖
cd bitcore
sudo su yum install gcc-c++ 
npm install
- 注意事项1：
```log
[14:55:07] I/config_source - curl -o/home/bitcore/bitcore.bak/packages/insight/node_modules/webdriver-manager/selenium/chrome-response.xml https://chromedriver.storage.googleapis.com/
events.js:
      throw er; // Unhandled 'error' event
      ^
Error: ESOCKETTIMEDOUT
```
没法在中国大陆的服务器上进行npm install
npm installl时，中国大陆服务器访问超时 https://chromedriver.storage.googleapis.com/

- 注意事项2：
```log
Error: Cannot find module './build/Debug/addon'
/bitcore/packages/bitcore-node/node_modules/heapdump/build/*
```
缺少addon，我是从别的地方拷贝过来的，理论上也可以通过npm rebuild获取吧

3. 配置bitcore.config.json
```conf
{
  "bitcoreNode": {
    "modules": ["./bitcoin", "./bitcoin-cash", "./ethereum", "./ripple"],
    "services": {
      "api": {
        "wallets": {
          "allowCreationBeforeCompleteSync": true
        },
        "rateLimiter": {
          "disabled": true,
          "whitelist": [
            "::ffff:127.0.0.1"
          ]
        }
      }
    },
    "chains": {
      "BTC": {
        "testnet": {
          "chainSource": "p2p",
          "trustedPeers": [
            { 
              "host": "bitcoin",
              "port": 18332
            }
          ],
          "rpc": {
            "host": "bitcoin",
            "port": 18333,
            "username": "gary",
            "password": "@gary123456"
          }
        }
      },
      "ETH": {
        "testnet": {
          "chainSource": "p2p",
          "trustedPeers": [
            {
              "host": "parity",
              "port": 30303
            }
          ],
          "provider": {
            "host": "parity",
            "protocol": "ws",
            "port": 8546
          }
        }
      },
      "XRP": {
        "mainnet": {
          "chainSource": "rpc",
          "provider": {
            "host": "rippled",
            "protocol": "ws",
            "port": "6006",
            "dataHost": "rippled"
          }
        }
      }
    }
  }
}
```
4. 启动
- 创建后台启动脚本 vim start.sh
```bash
#!/bin/bash
export PATH=$PATH:/home/bitcore/.nvm/versions/node/v10.20.1/bin/
export NODE_OPTIONS=--max_old_space_size=3145728
cd /home/bitcore/bitcore

logPath=/home/bitcore/bitcore/logs/log_`date +%Y-%m-%d`.log
npm run node >> ${logPath} 2>&1
```
- 启动
bash start.sh

### 运维BTC
1. bitcoin端口
  - rpc 18332
  - p2p 18333
2. bitcor默认端口
  - 3000
3. 获取块高的API
  curl 127.0.0.1:3000/api/BTC/mainnet/block/tip | grep height
4. 区块链游览器
  https://tbtc.bitaps.com/