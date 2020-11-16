#### 安装部署
1. 硬件配置
2c4g100g
ubuntu

2. JRE1.8

```shell
# 安装oracal-java环境- 失败
add-apt-repository -y ppa:webupd8team/java
apt-get update
apt-get -y install oracle-java8-installer
java -version

# 安装openjdk 环境
# 以下均在root用户下操作
apt-get update -y
apt-get install openjdk-8-jdk -y
java -version

# 卸载
 #若是oracle-jdk 
apt-get remove oracle-java8-installer
#若是openjdk
apt-get remove/purge openjdk* 

```

#### TestNet安装

```shell
cd /data
# 这里决定是用主网还是测试网
wget https://github.com/virtualeconomy/v-systems/releases/download/v0.2.0/v_systems_0.2.0_testnet.deb
sudo dpkg -i v_systems_0.2.0_testnet.deb

sudo mkdir -p /data/vsys/data
sudo chown -R vsys:vsys /data/vsys

# 更改配置文件
vim /etc/vsys/vsys.conf
更改存储目录
directory = /data/vsys

# 启动
systemctl start vsys.service
systemctl enable vsys.service
journalctl -u vsys.service -f

```

## 运维须知
API查看块高
curl -X GET --header 'Accept: application/json' 'http://localhost:9922/blocks/height'
测试节点
http://${IP}:9922/api-docs/index.html#!/blocks/height
超级节点
https://vsysrate.com/
官网
https://www.v.systems
钱包
https://www.v.systems/zh-tw/wallet.html
浏览器
https://explorer.v.systems/
wiki
https://github.com/virtualeconomy/v-systems/wiki
主网API
http://${IP}:9922/api-docs/index.html#/wallet