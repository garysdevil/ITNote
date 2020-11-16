Git
https://github.com/stellar/stellar-core
https://github.com/stellar/docker-stellar-core-horizon
- 链： steller
- 代币： XLM

#### 安装部署
Requirement
    Ubuntu 16.04
    docker 17.03.2-ce
    Ubuntu 16.04+
    docker 17.03.2-ce+
    2 Core CPU or above
    8G Memory or above
    300G Storage or above
    10Mbit/s bandwidth or above
    NTP service on

- 通过容器进行部署
```bash
# mainnet:
docker run --rm -it -v "/data/stellar:/opt/stellar" -p "8000:8000" --name stellar stellar/quickstart --pubnet
# 退出容器，配置文件中，export PER_HOUR_RATE_LIMIT改为72000000
vi /data/stellar/horizon/etc/horizon.env
# 后台启动
docker run -d -v "/data/stellar:/opt/stellar" -p "8000:8000" --name stellar stellar/quickstart --pubnet

# testnet:
docker run  -it -p "8000:8000" -v "/data/stellar:/opt/stellar" --name stellar stellar/quickstart --testnet
# 设置完数据库的密码后，退出，再启动容器。
docker start 容器id
```
```bash
nginx 连接节点的配置示范。
server {
        listen 80;
        server_name xml-testnet.cybex.io;
    location / {
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        proxy_pass   http://127.0.0.1:8000;
    }
       access_log  /var/log/nginx/xml-testnet_access.log ;
       error_log  /var/log/nginx/xml-testnet_error.log ;
}
```
#### 运维须知
- 默认端口
    rpc和p2p: 8000

- 指令查看块高（容器内操作）
    /usr/local/bin/stellar-core offline-info | grep num

- API查看块高
    curl 127.0.0.1:8000 | grep core_latest_ledger