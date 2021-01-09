
- 参考
    1. https://zhuanlan.zhihu.com/p/80909555
    2. https://freessl.cn/
    3. https://blog.csdn.net/ithomer/article/details/78075006


## letsencrypt.org
1. 申请获取证书
./certbot-auto certonly -d "*.domain.com" --manual --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory --no-bootstrap
2. 同一个域名每分钟最多能请求5次
## acme
### 安装acme
curl  https://get.acme.sh | sh
或者
https://github.com/acmesh-official/get.acme.sh

### 申请证书
- 参考 https://github.com/acmesh-official/acme.sh
1. http 方式
```conf
# nginx的域名必须是完全匹配模式
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

### acme自身升级
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

```bash
# 问题 {"message":"failed to update certificate: acme directory request failed: 20: unable to get local issuer certificate"}
缺少配置 KONG_LUA_SSL_TRUSTED_CERTIFICATE /etc/ssl/certs/ca-certificates.crt 或者 /etc/ssl/certs/ca-bundle.crt 
```
```bash
# 增加acme插件
curl http://localhost:8001/plugins \
    -d name=acme \
    -d config.account_email=garys163@163.com \
    -d config.tos_accepted=true \
    -d config.fail_backoff_minutes=1 \
    -d config.domains[]=test2.garys.top \
    -d config.domains[]=test3.garys.top
# 创建证书
curl https://test2.garys.top:8443 --resolve test2.garys.top:8443:127.0.0.1 -vk
# 手动更新证书
curl http://localhost:8001/acme -d host=mydomain.com
```

## 检测
1. 检测SSL证书过期时间  
echo '' | openssl s_client -servername www.baidu.com -connect www.baidu.com:443 2>/dev/null \
       |openssl x509 -noout -dates 2> /dev/null |grep notAfter |awk -F '=' '{print $2}'
2. 检测域名过期时间  
whois baidu.com | grep 'Registry Expiry Date: '|awk '{print $NF}' |awk -F 'T' '{print $1}'