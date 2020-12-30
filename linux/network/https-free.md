## free
- 参考
    1. https://zhuanlan.zhihu.com/p/80909555
    2. https://freessl.cn/
    3. https://blog.csdn.net/ithomer/article/details/78075006

./certbot-auto certonly -d "*.domain.com" --manual --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory --no-bootstrap

## acme
### 安装acme
curl  https://get.acme.sh | sh

### 申请证书
- 参考 https://github.com/acmesh-official/acme.sh
1. http 方式
```conf
server_name test2.garys.top
```
```bash
# ./acme.sh  --issue  -d test2.garys.top  --webroot  /etc/nginx/html
./acme.sh  --issue  -d test2.garys.top  --nginx
```
2. dns方式 失败
```bash
# https://github.com/acmesh-official/acme.sh/wiki/dns-manual-mode
./acme.sh --issue -d test.garys.top --dns --yes-I-know-dns-manual-mode-enough-go-ahead-please

dig  -t txt _acme-challenge.test.garys.top @8.8.8.8

./acme.sh --renew -d test.garys.top --yes-I-know-dns-manual-mode-enough-go-ahead-please
```

3. DNS API 方式

### 安装证书
```bash
./acme.sh --installcert  -d  test2.garys.top   \
        --key-file   /etc/nginx/ssl/test2.garys.top.key \
        --fullchain-file /etc/nginx/ssl/fullchain.cer \
        --reloadcmd  "service nginx force-reload"
```

### nginx 配置
```conf
server {
    listen       80 default_server;
    listen       [::]:80 default_server;
    server_name  test2.garys.top;
    listen       443 ssl;
    ssl_certificate   /etc/nginx/ssl/fullchain.cer;
    ssl_certificate_key  /etc/nginx/ssl/test2.garys.top.key;
}
```

## acme升级
```bash
# 升级 acme.sh 到最新版
acme.sh --upgrade

# 开启acme.sh自动升级:
acme.sh  --upgrade  --auto-upgrade

# 关闭acme.sh自动更新
acme.sh --upgrade  --auto-upgrade  0
```

## kong acme
- 参考
    1. https://github.com/Kong/kong-plugin-acme
    2. https://docs.konghq.com/hub/kong-inc/acme/0.2.2.html#parameters