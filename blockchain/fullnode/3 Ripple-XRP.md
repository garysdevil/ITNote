[TOC]
- 5M带宽跑，块高完成同步失败；10M带宽跑,失败。
- 使用apt的包进行安装
- rippled version 1.3.1
### 部署Ripple XRP
```shell
apt -y update

apt -y install apt-transport-https ca-certificates wget gnupg

wget -q -O - "https://repos.ripple.com/repos/api/gpg/key/public" |  apt-key add -

apt-key finger

echo "deb https://repos.ripple.com/repos/rippled-deb bionic stable" | tee -a /etc/apt/sources.list.d/ripple.list

apt -y update

apt -y install rippled

systemctl status rippled.service
# 修改以下文件，配置节点信息。例如 块高存储位置，日志位置等等。
vim /opt/ripple/etc/rippled.cfg
    # 如果从0开始同步快高则要添加如下配置
    [ips_fixed]
    s2.ripple.com 51235
# 修改以下文件，决定此节点是mainnet还是testnet
vim /opt/ripple/etc/validators.txt
    # testnet
    [validator_list_sites] https://vl.altnet.rippletest.net 
    [validator_list_keys] ED264807102805220DA0F312E71FC2C69E1552C9C5790F6C25E3729DEB573D5860
    # mainnet
    [validator_list_sites] https://vl.ripple.com
    [validator_list_keys] ED2677ABFFD1B33AC6FBC3062B71F1E8397C1505E1C42C64D11AD1B28FF73F4734
```
### 运维须知
1. 默认端口  
    p2p：51235  
    RPC：5005  
    wx: 6006  
2. 查看连接上的节点  
    /opt/ripple/bin/rippled peers  
3. 手动连接一个节点  
    connect <ip> [<port>]  
4. 指令查看块高  
    /opt/ripple/bin/rippled ledger | grep seqNum
5. 获取本地节点的信息  
    /opt/ripple/bin/rippled server_info  