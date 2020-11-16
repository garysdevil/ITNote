[TOC]
git仓库
https://github.com/tomochain/tomochain
- 部署文档
https://docs.tomochain.com/masternode/docker/

#### 准备
2 Core CPU or above
8G Memory or above
300G Storage or above
10Mbit/s bandwidth or above
NTP service on
docker 19+

### 部署 Vechain
- 部署方式：dcoker
```bash 主网
# 下载主网的块高镜像 
mkdir -p /data/tomochain/chaindata
wget https://chaindata.tomochain.com/20190813.tar
tar -xvf 20190813.tar -C /data/tomochain/chaindata/tomo/

# 配置启动
MASTERNODE_NAME='wx_tomo_maintest01' # 自定义,且全网唯一
BOOTNODES="enode://97f0ca95a653e3c44d5df2674e19e9324ea4bf4d47a46b1d8560f3ed4ea328f725acec3fcfcb37eb11706cf07da669e9688b091f1543f89b2425700a68bc8876@104.248.98.78:30301,enode://b72927f349f3a27b789d0ca615ffe3526f361665b496c80e7cc19dace78bd94785fdadc270054ab727dbb172d9e3113694600dd31b2558dd77ad85a869032dea@188.166.207.189:30301,enode://c8f2f0643527d4efffb8cb10ef9b6da4310c5ac9f2e988a7f85363e81d42f1793f64a9aa127dbaff56b1e8011f90fe9ff57fa02a36f73220da5ff81d8b8df351@104.248.98.60:30301"
STATS_WS_SECRET='getty-site-pablo-auger-room-sos-blair-shin-whiz-delhi'

CONTAINER_NAME='wx_tomo_maintest01' # 自定义
docker run -d --name <your name> \
  -e IDENTITY=$MASTERNODE_NAME \
  -e BOOTNODES=$BOOTNODES \
  -e NETSTATS_HOST=stats.tomochain.com \
  -e NETSTATS_PORT=443 \
  -e WS_SECRET=$STATS_WS_SECRET \
  -e NETWORK_ID=88 \
  -p 8545:8545 \
  -p 8546:8546 \
  -p 30303:30303 \
  -p 30303:30303/udp \
  -v /data/tomochain/chaindata:/tomochain/data \
  tomochain/node:stable
 ```

 ```bash 测试网
MASTERNODE_NAME='wx_tomo_testnet' # 自定义,全网唯一
STATS_WS_SECRET='anna-coal-flee-carrie-zip-hhhh-tarry-laue-felon-rhine'
BOOTNODES='enode://4d3c2cc0ce7135c1778c6f1cfda623ab44b4b6db55289543d48ecfde7d7111fd420c42174a9f2fea511a04cf6eac4ec69b4456bfaaae0e5bd236107d3172b013@52.221.28.223:30301,enode://ce1191bf9a634e7939676d136816ad84941b079c03d6a96e64cca35852363012169055c6879c644e821dc236a01d0499a1b7ff39e9518dbc00da87c7f1898604@13.251.101.216:30301,enode://46dba3a8721c589bede3c134d755eb1a38ae7c5a4c69249b8317c55adc8d46a369f98b06514ecec4b4ff150712085176818d18f59a9e6311a52dbe68cff5b2ae@13.250.94.232:30301'

CONTAINER_NAME='wx_tomo_testnet' # 自定义
docker run -d --name ${CONTAINER_NAME} \
  -e IDENTITY=$MASTERNODE_NAME \
  -e BOOTNODES=$BOOTNODES \
  -e NETSTATS_HOST=wss://stats.testnet.tomochain.com \
  -e NETSTATS_PORT=443 \
  -e WS_SECRET=$STATS_WS_SECRET \
  -e NETWORK_ID=89 \
  -p 8545:8545 \
  -p 8546:8546 \
  -p 30303:30303 \
  -p 30303:30303/udp \
  -v /data/tomochain/chaindata:/tomochain/data \
  tomochain/node:testnet

或者（不推荐）
https://docs.tomochain.com/masternode/tmn/
tmn start --name wx-testnet-node --net testnet --pkey 2abe0b258d33d635b97579b0940369e42843688750919671a06d4f2f3591f111
 ```


### 运维须知
1. 默认端口：
	p2p: 30303
	rpc: 8545
	ws: 8546
2. 查块日志
docker logs  -f -t --tail 100 容器ID

3. API查看块高
printf %d `curl -sS -H "Content-Type:application/json" 127.0.0.1:8545 -X POST  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' |  grep -Po 'result[" :]+\K[^"]+'`
- 官方IP
https://rpc.tomochain.com/blockNumber

4. 
curl --request POST   --url 127.0.0.1:8545   --header 'content-type: application/json'   --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":74}'

4. 区块链浏览器
	- 主网 https://scan.tomochain.com/blocks
	- 测试网 https://stats.testnet.tomochain.com/

### 升级步骤：
	1. 给原来的镜像打tag
	2. nmt 执行相关命令
	3. 修改docker内的hostconfig.json文件，添加下面的信息
	,"8545/tcp":[{"HostIp":"","HostPort":"8545"}],"8546/tcp":[{"HostIp":"","HostPort":"8546"}]
	4.关闭容器，重启docker，启动容器。
	5.查看日志，上区块链游览器查看全节点的恢复情况。
	升级后版本：1.5.4
