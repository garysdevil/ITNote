## Substrate
- Substrate 是一个构造区块链的“轮子”。
- 在Substrate之前，如果大家想要快速构造一条链，选择是非常少，而且可定制化程度也很低。基本上公链会fork Bitcoin，联盟链会直接使用Hyperledger。
- Substrate是一个开箱即用的构造区块链的SDK，从简单的智能合约，到中层的链上逻辑，或者底层的p2p网络、数据库、共识，都可以自由定制。

## 智能合约&DApp
- 智能合约是一小段存储在区块链中，能够自动执行合约条款的代码。
- DApp = 前端界面 + 智能合约 + token

- 原生代币：拥有自己的主链，使用链上的交易来维护账本数据
- 代币：依附于现有的区块链，使用智能合约来进行账本的记录


## DAG（Directed Acyclic Graph）有向无环图
- DAG区块链的与传统区块链的区别
    1. 单元：传统区块链组成单元是Block（区块），DAG组成单元是TX（交易）。
    2. 拓扑：传统区块链是由Block区块组成的单链，只能按出块时间同步依次写入，类似于单核单线程CPU；DAG是由交易单元组成的网络，可以异步并发写入交易，类似于多核多线程CPU。
    3. 粒度：区块链每个区块单元记录多个用户的多笔交易，DAG 每个单元记录单个用户交易。

- 最早在区块链中引入DAG概念作为共识算法的是2013年，http://bitcointalik.org 上由ID为avivz78的以色列希伯来大学学者提出，也就是GHOST协议，作为比特币的交易处理能力扩容解决方案；Vitalik在以太坊紫皮书描述的POS共识协议Casper，也是基于GHOST POW协议的POS变种。

## 拜占庭将军问题

- 拜占庭将军问题是 Leslie Lamport （2013年的图灵讲得主）用来为描述分布式系统一致性问题（Distributed Consensus）时在[论文中](http://lamport.azurewebsites.net/pubs/byz.pdf) 抽象出来一个著名的例子。 

- 拜占庭容错 BFT (Byzantine Fault Tolerance) 
    - 是这解决拜占庭将军问题的所有算法的一个总称。

- 实用拜占庭容错 PBFT（Practical Byzantine Fault Tolerance）
    1. 算法要求总节点数N>3F+1（其中F代表作恶节点）
    2. 系统的失效节点数量不得超过全网节点的1/3

- 联邦拜占庭协议（FBA，Federated Byzantine Agreement）

- 授权拜占庭容错算法（dBFT，Delegated Byzantine Fault Tolerance）

## 公链与联盟链
- 公链上的所有节点属于完全竞争、完全对立状态
- 联盟链上的各节点则是有限竞争并寻求整体利益的最大化

## IPFS（Inter Planetary File System）星际文件系统
- QUIC network transmission protocol is faster than TCP

### 常见的共识机制
1. 工作量证明（Proof-of-Work，PoW）

2. 权益证明（Proof-of-Stack，PoS，又译持有量证明）

3. 容量证明（Proof-of-space，PoSpace，又称 Proof-of-Capacity，PoC）


1. 存储证明（Proof-of-Storage, PoS）：为存储空间提供的证明机制。
2. 数据持有性证明（Provable Data Possession ，PDP)：用户发送数据给矿工进行存储，矿工证明数据已经被自己存储，用户可以重复检查矿工是否还在存储自己的数据。
3. 可检索证明（Proof-of-Retrievability，PoRet）：和PDP过程比较类似，证明矿工存储的数据是可以用来查询的。
4. 复制证明（Proof-of-Replication，PoRep）：存储证明PoS的一个实际方案，用以证明数据被矿工独立地保存，可以防止女巫攻击，外源攻击和生成攻击。
5. 空间证明（Proof-of-Space，PoSpace）：存储量的证明，PoSpace是PoW的一种，不同的是PoW使用的计算资源，而PoSpace使用的是存储资源。
6. 时空证明（Proof-of-Spacetime，PoSt）：证明在一段时间内，矿工在自己的存储设备上实际的存储了特定的数据。


- 活跃证明（Proof of Activity，PoA） 是一种PoW+PoS混合共识机制


## 默克尔树
- 默克尔树（Merkle tree，MT）是一种哈希二叉树，是存储数据的一种数据结构，1979年由Ralph Merkle发明。

- 比特币的一个区块大小大约是1M左右，可以保存4000笔交易记录。

## 
1. 零工经济即采用众包方式来标注数据
2. 共享经济即帮助参与数据贡献的人获取数据变现收
