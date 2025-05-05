---
created_date: 2021-07-01
---

[TOC]

- 参考
  1. https://zhuanlan.zhihu.com/p/80909555
  2. https://freessl.cn/
  3. https://blog.csdn.net/ithomer/article/details/78075006

## letsencrypt.org 获取免费证书

### certbot

```sh
domain=baidu.com
certbot certonly --webroot -w /etc/nginx/html -d www.${domain} -d ${domain}
```

### certbot-auto 官方已不再受支持

1. 申请获取证书

   - ./certbot-auto certonly -d "\*.domain.com" --manual --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory --no-bootstrap
   - 生成的文件
     - cert.pem 使用
     - chain.pem
     - fullchain.pem
     - privkey.pem 使用

2. 同一个域名每分钟最多能请求5次

## acme 自动获取更新证书

### 安装acme

curl https://get.acme.sh | sh
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
        --fullchain-file /etc/nginx/ssl/test2.garys.top.cer \
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

### 证书自动更新脚本

```bash
0 0 1 * * /root/.acme.sh/acme.sh --cron --home "/root/.acme.sh" --force
0 1 1 * * ${ssl_folder}=/opt/nginx && /root/.acme.sh/acme.sh --installcert  -d  garys.top --key-file   ${ssl_folder}/garys.top.key --fullchain-file ${ssl_folder}/garys.top.cer --reloadcmd  "nginx -s reload"
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

## kong-plugin-acme

- 参考
  1. https://github.com/Kong/kong-plugin-acme
  2. https://docs.konghq.com/hub/kong-inc/acme/0.2.2.html#parameters

### 使用

1. 问题

   1. 报错 {"message":"failed to update certificate: acme directory request failed: 20: unable to get local issuer certificate"}
   2. 原因 Kong缺少配置 lua_ssl_trusted_certificate
   3. 解决措施
      - KONG_LUA_SSL_TRUSTED_CERTIFICATE=/etc/ssl/certs/ca-certificates.crt (ubuntu系列容器)
      - KONG_LUA_SSL_TRUSTED_CERTIFICATE=/etc/ssl/certs/ca-bundle.crt (centos系列容器)

2. 创建证书

```bash
# 1 增加acme插件
email=
domain1=
domain2=
curl http://localhost:8001/plugins \
    -d name=acme \
    -d config.account_email=${email} \
    -d config.tos_accepted=true \
    -d config.fail_backoff_minutes=1 \
    -d config.storage=kong \
    -d config.domains[]=${domain1}
# 2. 增加域名，更新插件信息
curl http://localhost:8001/plugins/{plugin-id} \
    -d name=acme \
    -d config.account_email=${email} \
    -d config.tos_accepted=true \
    -d config.fail_backoff_minutes=1 \
    -d config.storage=kong \
    -d config.domains[]=${domain1} \
    -d config.domains[]=${domain2} -XPATCH

# 2 为域名${domain1}创建https证书
curl https://${domain1}:8443 --resolve https://${domain1}:8443:127.0.0.1 -vk

# 3 手动更新证书
curl http://localhost:8001/acme -d host=${domain1}
```

### 检测脚本

```bash

data=`curl  http://localhost:8001/certificates -s`
https_port=443
echo ${data} | jq .data | jq -c  '.[]' | while read i; do
    domain=`echo $i | jq '.snis[0]'`;
    domain="${domain%\"}"
    domain="${domain#\"}"
    expire_time=`echo '' | openssl s_client -servername ${domain} -connect ${domain}:${https_port} 2>/dev/null \
       | openssl x509 -noout -dates 2> /dev/null |grep notAfter |awk -F '=' '{print $2}'`
    
    expire_timestamp=`date -d "${expire_time}" +%s`
    cur_timestamp=`date +%s`
    left_timestamp=$[expire_timestamp - cur_timestamp]
    alarm_timestamp=$[60*60*24*7]

    # log
    echo "domain: $domain";
    echo "expire_time: $expire_time";  # 7days
    if [ ${left_timestamp} -lt ${alarm_timestamp} ];then 
        echo -1;
        # echo $i | jq '.'
    else 
        echo ${left_timestamp};
    fi
done
```

### 深入

1.

kong-plugin-acme如果选择了kong作为存储，则自动更新域名证书的信息会被存放在kong的acme_storage表中。\
如果acme_storage表的信息被更改或者删除，则自动更新域名证书的机制可能会失效。\
则只能手动检测触发更新 curl http://localhost:8001/acme -XPATCH\
或者删除插件再重新创建。

## 检测

1. 检测SSL证书过期时间\
   echo '' | openssl s_client -servername www.baidu.com -connect www.baidu.com:443 2>/dev/null \
   | openssl x509 -noout -dates 2> /dev/null |grep notAfter |awk -F '=' '{print $2}'

2. 检测域名过期时间\
   whois baidu.com | grep 'Registry Expiry Date: '|awk '{print $NF}' |awk -F 'T' '{print $1}'
