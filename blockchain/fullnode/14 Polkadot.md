### Polkadot部署
- 部署准生产网
- 参考 https://wiki.polkadot.network/docs/zh-CN/maintain-sync  "快速安装说明 (Linux)" 部分

1. 下载启动
curl -sL https://github.com/paritytech/polkadot/releases/download/v0.7.30/polkadot -o polkadot
curl -sL https://github.com/paritytech/polkadot/releases/download/v0.8.14/polkadot
curl -O https://github.com/paritytech/polkadot/releases/download/v0.8.0/polkadot
wget https://github.com/paritytech/polkadot/releases/download/v0.8.22/polkadot

sudo chmod +x polkadot

./polkadot --pruning archive --name "wx_kusama_node01" --chain kusama  -d /data/polkadot --rpc-external --ws-external --rpc-cors all

启动参数说明：
--pruning  archive      运行归档节点，同步所有的区块
--name  <NAME>          指定节点名
-d,--base-path  <PATH>  指定运行目录
--rpc-external          监听所有rpc接口
--rpc-external          监听所有websocket接口
--rpc-cors  all         允许远程访问节点需要开启
--rpc-port <PORT>       指定http rpc端口，默认9933
--ws-port <PORT>        指定websocket rpc端口，默认9944
--chain <network>         指定要使用的网络，默认为Polkadot CC1网络, kusama是准生产网。
--wasm-execution Compiled 使此节点使用更多的CPU和RAM，同步速度能达到4倍。建议在同步结束后关闭这个参数。
其他参数说明使用 --help 查看

2. 服务化
vi start.sh
```
log=/home/polkadot/logs/kusama`date '+%Y-%m-%d'`.log
/home/polkadot/polkadot --pruning archive --name "wx_kusama_node02"  -d /data/polkadot --rpc-external --ws-external --rpc-cors all --chain polkadot  >> $log 2>&1
```
vi /etc/systemd/system/polkadot.service
```conf
[Unit]
Description=Polkadot

[Service]
User=polkadot
Group=polkadot
ExecStart=/bin/bash /home/polkadot/start.sh
Restart=always

[Install]
WantedBy=multi-user.target
```

3. 安装时遇到的错误
libstdc++.so.6: version `GLIBCXX3.4.22’ not found
```bash 解决办法
# https://blog.csdn.net/u011961856/article/details/79644342?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.nonecase&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.nonecase
strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 | grep GLIBCXX # 查看当前版本的GLIBCXX
apt-get install libstdc++6 # 安装最新的libstdc++6
# 没有安装成功则添加ppa源，再更新安装
sudo add-apt-repository ppa:ubuntu-toolchain-r/test 
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
# 
strings /usr/lib/x86_64-linux-gnu/libstdc++.so.6 | grep GLIBCXX
```
### Polkadot运维
0. 默认端口
  - RPC 9933
  - WS 9944
  - P2P 30333
1. 区块链浏览器
    https://telemetry.polkadot.io/#list/Kusama

2. RPC文档：
    https://wiki.polkadot.network/docs/en/build-node-interaction#polkadot-rpc

3. API获取本地块高：
echo $((`curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "chain_getBlock"}' http://localhost:9933/ | jq .result.block.header.number | tr \" " "`))

 


### subscan-essentials 部署
https://github.com/garysHub/subscan-essentials.git

1. vi docker-compose-full.yml
2. docker-compose build
3. docker-compose -f docker-compose-full.yml up -d mysql
4. docker-compose -f docker-compose-full.yml up -d

5. 获取块高同步信息
进入redis，get "kusama:FillAlreadyBlockNum"
6. 从特定块高开始同步，需要先关闭subscan-daemon和subscan-api，修改完值后再启动。
进入redis， set "kusama:FillAlreadyBlockNum" 数值
```Dockerfile docker-compose-full.yml
version: "2.4"

services:
  redis:
    image: redis:3.2.11
    hostname: redis
    restart: always

  mysql:
    image: mysql:latest
    hostname: mysql
    volumes:
      - 'db-data:/var/lib/mysql'
    ports:
      - '33061:3306'
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=subscan
    restart: always
  subscan-api: &app_base
    image: scan/backend
    init: true
    build: .
    environment:
      MYSQL_HOST: mysql
      MYSQL_PASS: 'root'
      MYSQL_DB: 'subscan'
      REDIS_ADDR: redis:6379
      CHAIN_WS_ENDPOINT: 'ws://${IP}:9944'
      NETWORK_NODE: 'polkadot'
      WEB_HOST: 'http://subscan-api:4399'
    ports:
      - '3000:4399'
#    networks:
#      - app_net
    command: ["/subscan/cmd/subscan","--conf","../configs"]
    depends_on:
      - redis
      - mysql
    restart: always
  subscan-daemon:
    <<: *app_base
    image: scan/backend
    ports: []
    command: ["python","run.py","substrate"]
    depends_on:
      - redis
      - mysql
    restart: always
volumes:
  db-data:
```