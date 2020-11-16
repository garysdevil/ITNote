[TOC]
 [官网详情链接](https://www.irisnet.org/docs/get-started/mainnet.html#upgrade-to-validator-node)
### 部署Iris
```bash
# 安装go环境
goPath=~/go
mkdir -p ${goPath}/go/bin
echo "export GOPATH=$HOME/go" >> ~/.bashrc
echo "export GOBIN=$GOPATH/bin" >> ~/.bashrc
echo "export PATH=$PATH:$GOBIN" >> ~/.bashrc
source ~/.bashrc

# 1、安装iris
git clone --branch v0.16.0 https://github.com/irisnet/irishub
cd irishub
# source scripts/setTestEnv.sh # to build or install the testnet version
make get_tools install

# 2、初始化为主网节点
homePath=/data/iris/iris
iris init --moniker=moniker-wx --home=${homePath} --chain-id=irishub cd /config/ rm genesis.json rm config.toml
# chain-id=irishub代表是IRISnet主网

# 下载公链的配置文件，并替换
curl -o ~/.iris/config/config.toml https://raw.githubusercontent.com/irisnet/mainnet/master/config/config.toml
curl -o ~/.iris/config/genesis.json https://raw.githubusercontent.com/irisnet/mainnet/master/config/genesis.json
mv config.toml ${homePath}/config/  && mv genesis.json ${homePath}/config/

# 3、启动
p2pLogPath=/data/iris/iris/node.log
iris start --home=${irisHomePath} > ${p2pLogPath} 2>&1

rpcLogPath=/data/iris/iriscli/server.log
irislcd  start --node=tcp://localhost:26657 --laddr=tcp://0.0.0.0:1317 --chain-id=irishub --home=${homePath} --trust-node >  ${rpcLogPath} 2>&1

```
### 运维须知
1. 默认端口
    rpc: 1317
    p2p: 26656
2. 查看节点信息
    iriscli status
3. 指令查看块高
    iriscli status | grep latest_block_height 
1. API查看块高 
    curl http://127.0.0.1:1317/blocks/latest
2. 通过快照同步快高
    iris snapshot --home=<path-to-your-home>


20191129更新：
跳转：3447000


