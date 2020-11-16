[TOC]
- git仓库
https://github.com/nervosnetwork/ckb
- 代币：CKB
- 链：Nervos
### 部署Nevos
- 使用二进制进行安装部署
```bash
useradd -r -m nervos && chown nervos.nervos /data && su - nervos && cd /data/
# 1. 下载资源
wget https://github.com/nervosnetwork/ckb/releases/download/v0.26.0/ckb_v0.26.0_x86_64-unknown-linux-gnu.tar.gz
# 2. 
tar xzvf ckb_v0.26.0_x86_64-unknown-linux-gnu.tar.gz
mv ckb_v0.26.0_x86_64-unknown-linux-gnu ckb
cd ckb

# 3. 获取测试网定制化的规格配置
wget https://gist.github.com/doitian/573513c345165c0fe4f3504ebc1c8f9f/raw/3032bed68550e0a50e91df2c706481e80b579c70/aggron.toml
# 初始化测试网A
./ckb init --import-spec ./aggron.toml --chain testnet
# 初始化主网B
./ckb init --chain mainnet --force
# ./ckb init --list-chains 查看所有的环境配置

# 5. 启动进程
nohup /data/ckb/ckb run -C /data/ckb/ > /data/debug.log 2>&1 &
```
### 运维须知
- 区块链游览器 https://explorer.nervos.org/
- API文档 https://docs.nervos.org/api/rpc.html

- 默认端口
    1. rpc: 8114
    2. p2p: 8115

- 常用CLI
    1. 查看节点信息 ./ckb-cli rpc get_blockchain_info
    2. 查看块高 ./ckb-cli rpc get_tip_block_number
    
- API查看块高
```bash
echo '{
    "id": 2,
    "jsonrpc": "2.0",
    "method": "get_tip_block_number",
    "params": []
}' \
| tr -d '\n' \
| curl -H 'content-type: application/json' -d @- \
http://localhost:8114

printf %d 16进制
```