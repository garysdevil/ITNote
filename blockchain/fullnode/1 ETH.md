[TOC]
#### 部署ETH-主网
- 使用二进制进行安装部署
```shell
# 0.创建部署目录
	mkdir /data && cd /data
# 1.下载程序压缩包(请自行选择程序版本)
	curl -O https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.9.7-a718daa6.tar.gz

# 2.解压缩包
	tar xzvf geth-linux-amd64-1.8.15-89451f7c.tar.gz geth
# 3.后台启动
	nohup /data/geth/geth --nat=extip:公网IP --rpc --rpcaddr 0.0.0.0 --ws --wsaddr 0.0.0.0 --wsport 8544  --datadir /data/ethereum --rpcvhosts=* > /data/geth/nohup.out 2>&1 &  
参数讲解：  
--datadir 数据块目录
--bootnodes Geth通过一种称为发现协议的方法来寻找对等节点。在发现协议中，节点之间相互移动以发现网络上的其他节点。一开始，geth使用了一组bootstrap节点，这些节点的端点记录在源代码中。可以通过--bootnodes参数修改一开始的引导节点

要在启动时更改引导节点，请使用--bootnodes选项并用逗号分隔
```
- 部署时遇到的问题：
	1. 本地全节点无法连接到任何节点
    	+ 本地的时间不正确，正确的本地时间是以太坊网络所必需的，请检查你的系统时间并同步系统时间（例如命令： sudo ntpdate -s time.nist.gov），本地时间误差达到12秒都能导致0连接的情况发生。
    	+ 一些防火墙设置项会防止UDP数据流拥堵，你可以尝试通过命令 admin.addPeer() 手动添加一些静态节点来解决这个问题。
- 同步过程
	1. Imported new block headers
	2. Imported new block receipts
	3. Imported new state entries
	4. Imported new chain segment
- 同步完成  10088165 227G
#### 运维须知-主网
1. 默认端口
	1. p2p：30303
	2. ws: 8544
	3. rpc: 8545

2. 获取块高的API
printf %d `curl -sS -H "Content-Type:application/json" 127.0.0.1:8545 -X POST  --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' |  grep -Po 'result[" :]+\K[^"]+'`

3. 查看交易信息
curl -sS -H "Content-Type:application/json" 127.0.0.1:8545 -X POST  --data '{"jsonrpc":"2.0","method":"eth_getTransactionByHash","params":["0xe82ada99b9c9ab2daffe208035d6f2fba78fea60df6ea9b41c2e99a3054bbe34"],"id":1}' 

4. 首先进入交互界面-指令操作
	./geth attach --datadir /data/ethereum
	或 geth attach geth.ipc
	0. 总览
		eth 所有方法
		net 网络信息
		admin  节点的配置信息
		miner 矿工的方法
		web3
	1. 获取连接节点的数量  
		net.peerCount  
	2. 查看网络是否可用  
		net.listening  
	3. 查看networkid  
		admin.nodeInfo.protocols.eth.network    
	3. 查看所有的连接节点  
		admin.peers  
		admin.peers.forEach(function(p) {console.log(p.network.remoteAddress);})  
	4. 查看此节点的地址  
		admin.nodeInfo.enode  
	5. 添加静态连接节点。两个节点想要联通必须保证网络是可用的，并且指定相同的networkid  
		admin.addPeer("enode://74410cd0aaeffd52f40e65992ae2e9d6dfb33a190f0904a39542382ae91f511581c3e4ca1450c89d7bfc61b833413aaefa093b069309af4699b2df2e16ed7525@13.229.57.82:30303")  
	或者在以下文件添加  
		<datadir>/static-nodes.json  
		```conf
		[
			"enode://512630c5472003d8e6bdfe81e256230ac0d8034838739f31b982e2ff0a3014e9cc1844600a5efa3e291168923f2ef474b36f881a01912b683b3af5414a88d9cc@13.229.57.82:30303"
		]
		```
	6. 查看同步了的块高/查看块高同步的百分比（未同步完成时）  
		eth.syncing  
		console.log(parseInt(eth.syncing.currentBlock/eth.syncing.highestBlock*100,10)+'%')	  

	7. 账户挖矿交易相关
		1. personal.newAccount()
		2. eth.accounts
		3. eth.getBalance("账户地址")
		4. 挖矿所得账户会进入矿工账户，称呼为coinbase，默认情况下coinbase是本地账户中的第一个账户 eth.coinbase
		5. 设置矿工账户 miner.setEtherbase()
		6. wei是以太币的最小单位，一个以太币=10的18次方个wei，将wei换算为以太币web3.fromWei()  web3.toWei()
		7. 交易 eth.sendTransaction(from:eth.accounts[0],to:eth.accounts[1],value:1)
		8. personal.unlockAccount(钱包地址)
		9. 查看链上正在进行交易的数量 txpool.status 
		10. 查看交易信息 eth.getTransaction("交易hash")
		11. 通过区块号查看交易信息 eth.getBlock(区块号)
5. 导出块高  
	./geth export 保存的文件位置 块高开始位置 块高的结束位置 --datadir /data/ethereum/ --syncmode "fast"  
	参数解释：  
	--datadir  数据块的目录位置  
	--syncmode  导出模式，共有三种 "full","fast","light"   

6. 导入块高
	./geth import 被导入的文件 --datadir /data/ethereum/ --syncmode "fast" --cache 2048
 
7. 导出导入测试：  
	块高：0-8990000
	配置 4C 8G 
	导出耗时17分钟
	导入耗时 （--cache 4096 耗内存13G左右） 7小时4分钟，达到2430000多时被oom掉；暂时将cpu和内存改为8C 32G
	105G的块高压缩包解压时间2-3个小时，压缩为64G。
	eth.block 进行md5验证需要10分钟左右

8. 公共的接口调用（被封装过的）
	https://ropsten.etherscan.io/apis
9. 区块链游览器
	主网：https://etherscan.io/
	测试网：https://ropsten.etherscan.io/

10. gas解释 https://www.jianshu.com/p/36caba297e14

11. 
Synchronisation failed, dropping peer    peer=1a32db2cf244288e err="retrieved hash chain is invalid"
尝试删除最前面的一部份数据，再开始同步 ----- 任然出现此条错误
debug.setHead("0x637cc0")  6520000块高

#### Eth测试网
- Kovan PoA算法，Parity专用
- Ropsten PoW算法，支持Parity和Get
- Rinkeby PoA共识算法，Geth专用
参考文档
- https://orange.xyz/p/113
- https://my.oschina.net/kunBlog/blog/1552073
水龙头：
https://github.com/bokkypoobah/WeenusTokenFaucet
https://www.liankexing.com/notetwo/12995

##### Ubuntu16部署parity Kovan
- Parity由Ethcore开发，为Rust语言写的全节点客户端程序。
- https://www.mycryptopedia.com/how-to-install-and-run-an-ethereum-parity-node/
- 部署文档 https://www.dazhuanlan.com/2020/01/04/5e1009dd10a04/
- 配置文档 https://paritytech.github.io/parity-config-generator/#config=eyJfX2ludGVybmFsIjp7ImNvbmZpZ01vZGUiOiJhZHZhbmNlZCIsInBsYXRmb3JtIjoiTGludXgifSwicGFyaXR5Ijp7ImNoYWluIjoia292YW4ifSwibWluaW5nIjp7Imdhc19mbG9vcl90YXJnZXQiOiIxMDAwIiwibWluX2dhc19wcmljZSI6MTV9fQ==
- 安装包链接 https://github.com/openethereum/openethereum/releases
1. 下载
curl -O https://github.com/openethereum/openethereum/releases/download/v3.0.0-alpha.1/openethereum-v3.0.0-alpha.1-ubuntu-16.04.zip

deb安装后，会在/usr/bin/下生成可执行文件。
2. 配置文件
config.toml
```conf
[parity]
chain = "kovan" //正式链为mainnet
base_path = "/opt/parity"
[network]
port = 30304
[rpc]
disable = false
port = 8547
interface = "0.0.0.0"
apis = ["web3", "eth", "net", "parity", "traces", "rpc", "secretstore", "personal"]
hosts = ["none"]
[websockets]
disable = false
port = 8546
interface = "0.0.0.0"
origins = ["none"]
apis = ["web3", "eth", "pubsub", "net", "parity", "traces", "rpc", "secretstore", "personal"]
hosts = ["none"]
```
3. 启动
nohup parity -l sync=debug,rpc=trace --config config.toml > parity.log 2>&1 &
##### Ubuntu16部署eth rinkeby
curl -O https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.9.13-cbc4ac26.tar.gz
curl -O https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.9.14-6d74d1e5.tar.gz
/data/geth/geth --datadir /data/geth/data/rinkeby --rinkeby
/data/geth/geth --rpc --rpcaddr 0.0.0.0 --rpcport 8545 --ws --wsaddr 0.0.0.0 --datadir /data/geth/data --rpcvhosts=* --rinkeby

##### 运维
1. 默认端口
	- rpc 8547

2. 查看钱包地址交易信息 
https://kovan.etherscan.io/address/0x913f09c0640df1c3fbee8206715d770d8ce6cdef

3. 创建解锁账户
```
parity account new
parity –unlock <account no> –password <filename>
```
4. 版本查看
./parity --version

5. 区块链游览器 rinkeby网络
https://kovan.etherscan.io/
#### eth索引库
https://github.com/Adamant-im/ETH-transactions-storage
https://git.i.garys.top/project/src/eth-indexer

0. 部署 全节点
1. 安装 Postgresql 10.5 或 11
2. 安装 Postgrest
3. 安装 python3.6环境，安装python3.6的pip或者pip3
4. 启动服务器操作
createuser -s {yourusername}
CREATE DATABASE index;
psql -f create_table.sql {yourDB}

pip3 install web3
pip3 install psycopg2
5. 启动服务
python3.6 you/path/to/script/ethsync.py {yourDB}

服务化 ethstorage.service

##### 主网索引库同步问题
索引库同步到 4908668 时出现问题。
```log
Jun 08 11:17:38 hnpvmnn01 bash[29892]: Traceback (most recent call last):
Jun 08 11:17:38 hnpvmnn01 bash[29892]:   File "/data/eth-indexer/ethsync.py", line 121, in <module>
Jun 08 11:17:38 hnpvmnn01 bash[29892]:     insertion(block, transactions)
Jun 08 11:17:38 hnpvmnn01 bash[29892]:   File "/data/eth-indexer/ethsync.py", line 92, in insertion
Jun 08 11:17:38 hnpvmnn01 bash[29892]:     (time, fr, to, value, gas, gasprice, blockid, txhash, contract_to, contract_value))
Jun 08 11:17:38 hnpvmnn01 bash[29892]: psycopg2.errors.ProgramLimitExceeded: index row size 3984 exceeds maximum 2712 for index "con
Jun 08 11:17:38 hnpvmnn01 bash[29892]: HINT:  Values larger than 1/3 of a buffer page cannot be indexed.
Jun 08 11:17:38 hnpvmnn01 bash[29892]: Consider a function index of an MD5 hash of the value, or use full text indexing.

```
同步极慢，从0到4908668块高花销了2周
dev主网同步到4908668后从10222000开始同步
prd主网同步到4857565后从10222000开始同步