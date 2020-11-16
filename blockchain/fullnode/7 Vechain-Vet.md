[TOC]
- 参考链接
https://github.com/vechain/thor
- 链 Vechain
- 币 VET
- 语言 go
- 进程 thor
### 部署 Vechain
- 部署方式源码
```bash
# 春节用户
useradd -m -r thor
su - thor
# 1. 安装go环境
# 2. 下载源码
git clone https://github.com/vechain/thor.git
# 3.编译
make dep
make
# 4. 运行
/home/thor/thor/bin/thor --network test --api-addr 0.0.0.0:8669 --data-dir /opt/thor_data
# 主网为 --network main
 ```
### 运维须知
1. 默认端口：
    - p2p: 11235
    - rpc: 8669
2. API查看块高
    curl http://127.0.0.1:8669/blocks/best
3. 区块链浏览器
    - 主网: https://explore.vechain.org/
    - 测试网：https://explore-testnet.vechain.org/