[TOC]
- 参考文档
https://tezos.gitlab.io
### 部署 Tezos
- 部署方式docker
1. 硬件要求  
   最低2C4G，否则会出现同步缓慢，磁盘吞吐量飙升

```shell
# 安装docker-compose
yum -y install python-pip
pip install docker-compose 

# 下载部署脚本(根据脚本名字区分是否是测试网)
# 主网
wget -O mainnet.sh https://gitlab.com/tezos/tezos/raw/master/scripts/alphanet.sh
chmod +x mainnet.sh
mv mainnet.sh /usr/local/bin
# 测试网
wget https://gitlab.com/tezos/tezos/raw/master/scripts/alphanet.sh 被废弃了
wget -O babylonnet.sh https://gitlab.com/tezos/tezos/raw/babylonnet/scripts/alphanet.sh
chmod +x alphanet.sh
mv alphanet.sh /usr/local/bin

# 禁止镜像自动更新
cat > /etc/profile.d/tezos.sh << "EOF"
export TEZOS_ALPHANET_DO_NOT_PULL=yes
export TEZOS_MAINNET_DO_NOT_PULL=yes
EOF
source /etc/profile.d/tezos.sh

# 启动fullnode节点(会自动拉镜像，并启动) 必须指定rpc端口否则RPC端口可能不开启
# 诺想改变卷目录则需要修改mainnet.sh
mainnet.sh node start --rpc-port 0.0.0.0:8732
```

### 运维须知
1. 默认端口
    - p2p：9732
    - rpc：8732

2. 浏览器
    - 主网  
    https://tzscan.io/ 废弃
    https://tezos.id/
    - 测试网  
    https://alphanet.tzscan.io/ 废弃
    https://babylonnet.tezos.id/

3. 数据目录  
   /data/docker/volumes/mainnet_node_data/_data/data
    
4. 常用命令
mainnet.sh node <start|stop|status|log>

5. 指令查看块高 
  - mainnet.sh head

6. tezos-node shell 内的命令
```shell
1. 生成节点id  
  tezos-node identity generate
2. 清理无效的块信息
  tezos-admin-client unmark all invalid blocks
3. 生成用户 
  tezos-client gen keys bob
4. 通过官方的json文件，生成含有一定金额的用户
  tezos-client activate account alice with "tz1__xxxxxxxxx__.json"
5. 列出所有用户
  tezos-client list known contracts
6. 获取用户的金额 
  tezos-client get balance for tz1gSoJR8FaoKvRH1T31uLSMuHbQMyYdvZTP
```

7. API查看块高
  - 本地 curl http://127.0.0.1:8732/chains/main/blocks/head/header | grep level
  - 官网主网 curl https://api.tzstats.com/explorer/block/head | grep height
