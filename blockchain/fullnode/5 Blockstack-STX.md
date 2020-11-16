- git仓库
https://github.com/blockstack/blockstack-core
### 部署Blockstack STX
- 使用pip安装, 版本v20.0.9.0
```shell
# 官方文档 https://github.com/blockstack/blockstack-core

# 安装依赖
apt-get update && sudo apt-get install -y python-pip python-dev libssl-dev libffi-dev rng-tools libgmp3-dev
pip install pyparsing
# 安装并更新blockstack
pip install blockstack --upgrade

mkdir /data/STX
adduser STX -m -d /data/STX -p 0
# 进行配置
blockstack-core configure --working-dir /data/STX/blockstack-server
# 拉取块高
blockstack-core --debug fast_sync  --working-dir /data/STX/blockstack-server
# 启动
blockstack-core --debug  start --working-dir /data/STX/blockstack-server
# 关闭
blockstack-core  stop --working-dir /data/STX/blockstack-server
```
### 运维须知
1. 默认端口  
    - rpc_port : 6270
    - p2p_port : 6264
2. 查看进程存活 
    - curl http://localhost:6270/v1/ping
3. API查看本地块高
    - curl http://localhost:6270/v1/info | grep "last_block_processed"
4. API查看官方的块高 
    - curl https://core.blockstack.org/v1/info  | grep "last_block_processed"

5. 从本地节点查看块高交易信息
   - curl http://127.0.0.1:6270/v1/blockchains/bitcoin/operations/608484
6. 从官方节点查看块高交易信息
    - https://core.blockstack.org/v1/blockchains/bitcoin/operations/617322
7. 区块链游览器
    - https://explorer.blockstack.org/