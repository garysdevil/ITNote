[TOC]
- git仓库
https://github.com/input-output-hk/jormungandr
- 相关资料
https://iohk.zendesk.com/hc/en-us/articles/360039342934-How-to-install-Jormungandr-Networking-Linux-
https://input-output-hk.github.io/jormungandr/introduction.html
- 技术问题：https://forum.cardano.org/c/developers/29/l/top
- 本文档的安装部署未按照以上链接操作，主要基于尧神的文档
- 团队：IOHK
- 链： Cardano
- 代币：ADA
- 代码：nodejs

#### 安装部署
- docker
- ubuntu16.04+
- nodejs v8
- 4 Core CPU or above
- 16G Memory or above
- 200G Storage or above
- 10Mbit/s bandwidth or above
- NTP service on

Setup adalite Guide
##### 安装全节点
- 安装方式 docker-compose
- 测试环境
- 先安装docker和docker-compose 
  - 参考文档： https://gist.github.com/garyssdevil/4697c90aff1a93341c4d8085e421dc3e
```bash
# 1. 创建系统用户，此用户的UID必须是999.
useradd -r -m cardano
# 2. 将此用户添加进docker组里
usermod -aG docker cardano
# 3. 以ADA用户身份进入/dada/文件夹
chown cardano.cardano /data && su - cardano
cd /data/
# 4. 下载安装脚本-lightweight wallet
git clone https://github.com/vacuumlabs/adalite-backend-service.git

# 5. 配置，修改docker的数据目录路径
cd adalite-backend-service/docker/
mv env.example	.env.ada
vim .env.ada 
# 修改数据目录为 /data/docker_data
# ICARUS_IMPORTER_HOST_PORT=8200

# 修改容器配置，使其随服务器自行启动。
# restart: always

# 6. 启动
./manage_containers.sh ada start-normal
chown -R cardano.cardano /data/docker_data
./manage_containers.sh ada start-normal
```

##### 区块链游览器 /基于尧神的文档
```bash
git clone https://github.com/input-output-hk/cardano-sl.git
cd cardano-sl
git checkout 3.2.0 

# 创建nixbld用户组以及用户，安装Nix包管理工具时需要用到 
groupadd nixbld 
for n in $(seq 1 10); do useradd -c "Nix build user $n" -d /var/empty -g nixbld -G nixbld -M -N -r -s "$(which nologin)" nixbld$n; done
curl https://nixos.org/nix/install | sh

source ~/.nix-profile/etc/profile.d/nix.sh

# 编译，4C或16C都是耗时7个小时这样
nix-build -A connectScripts.mainnet.explorer -o connect-explorer-to-mainnet
##start  以root用户权限启动
mkdir -p /data/cardano-sl_data/logs
cd /data/cardano-sl_data
nohup /data/cardano-sl/connect-explorer-to-mainnet > ./logs/explorer`date '+%Y%m%d%H%M%S'`.log 2>&1 &

# api文档 https://cardanodocs.com/technical/explorer/api/

```

##### 运维须知
- 默认端口
  1. 数据库：5432
  2. ada-importer: 8200映射至8202
  3. ada-service: 8080
  4. rpc：8100 （需要安装区块链游览器）
- 区块链游览器,主网
https://adascan.net/
https://cardanoexplorer.com/
- 查看官网块高
https://cardanoexplorer.com/api/blocks/pages

- API查看块高
curl  127.0.0.1:8100/api/blocks/pages | grep cbeBlkHeight


