文档
https://platonnetwork.github.io/Docs/#/zh-cn/Network/[Chinese-Simplified]-%E8%BF%9E%E6%8E%A5%E5%85%AC%E6%9C%89%E7%BD%91%E7%BB%9C

区块链游览器
https://platscan.test.platon.network/


### 安装部署
- 安装文档
https://devdocs.platon.network/docs/zh-CN/Install_Node/
- 节点秘钥生成文档：
https://platonnetwork.github.io/Docs/#/zh-cn/Node/_[Chinese-Simplified]-%E9%92%B1%E5%8C%85%E6%96%87%E4%BB%B6%E4%B8%8E%E8%8A%82%E7%82%B9%E5%AF%86%E9%92%A5?id=%e8%8a%82%e7%82%b9%e5%af%86%e9%92%a5

- 硬件要求
Ubuntu 18.04.1 及以上
cpu: 4核
内存：8G
磁盘：> 100G

1. 安装并运行NTP服务
apt-get update
apt-get install -y gnupg2 curl software-properties-common ntp
systemctl enable ntp && sudo systemctl start ntp

2. 安装PlatON
add-apt-repository ppa:ppatwo/platon 
apt-get update 
apt-get install platon0.12.1 

执行完上述命令后，platon和keytool二进制就已经成功安装到您系统上的/usr/bin目录里

3. 查看版本
platon version


4. 创建节点密钥
    1. 创建数据目录
        mkdir   /opt/platon/data
    2. 生成节点密钥文件
        export datadir=/opt/platon/data
    3. 生成节点公私钥：
          keytool genkeypair | tee >(grep "PrivateKey" | awk '{print $2}' >$datadir/nodekey) >(grep "PublicKey" | awk '{print $3}' >$datadir/nodeid)
    4. 生成节点BLS公私钥：
         keytool genblskeypair | tee >(grep "PrivateKey" | awk '{print $2}' >$datadir/blskey) >(grep "PublicKey" | awk '{print $3}' >$datadir/blspub)


6. 关于网络的说明

PlatON目前有2个公有网络，一个是还未正式上线的、独立运行的 PlatON 主网络，ChainID为 100。
另外一个是已经于北京时间 2020-2-20日 正式上线的用来对开发者开放的测试网络贝莱世界，ChainID为 102。
主网目前还未正式上线。

         在加入PlatON公有网络前请确保服务器本地具备以下条件 ：
          1. 已经按照PlatON安装指南安装好PlatON环境或编译好PlatON可执行文件’platon’和’keytool’。
          2. 已经按照节点密钥章节在’~/platon-node/data’目录下生成了节点私钥和节点BLS私钥。

7. 启动归档节点
    - 执行以下命令即可启动验证节点加入贝莱世界:
cd /data/platon/
nohup platon --identity platon --datadir ./data --port 16789 --db.nogc  --rpcvhosts \*  --testnet --rpcport 6789 --rpcapi "db,platon,net,web3,admin,personal" --rpc --nodekey ./data/nodekey --cbft.blskey ./data/blskey --verbosity 3 --rpcaddr 0.0.0.0 --syncmode "full" > ./data/platon.log 2>&1 &


参数说明：
--identity	指定网络名称
--datadir	指定 data 目录路径
--rpcaddr	指定 rpc 服务器地址
--rpcport	指定 rpc 协议通信端口
--rpcapi	指定节点开放的 rpcapi 名称
--rpc	指定 http-rpc 通讯方式
--nodekey	指定节点私钥文件
--cbft.blskey	指定节点 bls 私钥文件
--testnet	指定连接到测试网络，不指定默认运行主网络
--syncmode	fast：快速同步模式，full：全同步模式
--db.nogc	开启归档模式

### 运维
1. 默认端口
    p2p: 16789 
    rpc: 6789 
2. 指令操作
- 通过http方式进入platon控制台：
    platon attach http://localhost:6789
    - 查看节点的peers：
        admin.peers
    - 查看当前块高：
        platon.blockNumber
    - 通过hash获取交易信息
        platon.getTransactionReceipt(’hash‘)
    - 本地节点的交易池
        platon.pendingTransactions
- platon attach http://localhost:6789 -exec platon.blockNumber
3. API 操作

4. 查看钱包地址交易信息
    - 从区块链游览器
        https://platscan.test.platon.network/address-detail?address=0x1c2d7dbd54b803121d829cfe00893f1a6352e5a2
    - 从本地节点
        http://${IP}:3000/platontxs?and=(contract_to.eq.,or(txfrom.eq.0x1c2d7dbd54b803121d829cfe00893f1a6352e5a2,txto.eq.0x1c2d7dbd54b803121d829cfe00893f1a6352e5a2))&order=time.desc&limit=10&offset=0

http://${IP}:3000/platontxs?and=(contract_to.eq.,or(txfrom.eq.0x1c2d7dbd54b803121d829cfe00893f1a6352e5a2,txto.eq.0x1c2d7dbd54b803121d829cfe00893f1a6352e5a2))&order=time.desc&limit=10&offset=0

### 索引库
https://git.i.garys.top/project/src/platon-indexer

pip uninstall web3
pip install web3==4.9.0

pip install client_sdk_python