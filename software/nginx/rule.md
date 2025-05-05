---
created_date: 2020-11-16
---

[TOC]

### 七层反向代理

```conf
http {
    upstream backend_service {
        server 10.0.0.83:7080 backup; 
        server 10.0.0.84:7080 backup;  backup 表示其它所有的非backup Server down或者忙的时候，请求backup机器；所以这台机器压力会最轻。
        server 10.0.0.85:8980 weight=2;  # weight  默认为1.weight越大，负载的权重就越大。
        server 10.0.0.86:8980 down;  # down 表示当前的Web Server暂时不参与负载。
    }
    server{
        listen 80 default_server;
        server_name _;
        location / { 
            proxy_pass http://backend_service; 
        }
    }
    include /etc/nginx/http.d/*.conf;
}
```

### 四层反向代理

```conf
stream {
    upstream backend_instance {
        server 127.0.0.2:12345 weight=5;
        server 127.0.0.1:12345 max_fails=3 fail_timeout=30s;
    }
    server {
        listen 12345;
        proxy_pass backend_instance;
    }
    include /etc/nginx/tcp.d/*.conf;
}
```

### url访问路径规则

```
空	location后没有参数直接跟着URI，表示前缀匹配，代表跟请求中的URI从头开始匹配。
=	用于标准 uri 前，要求请求字符串与其严格匹配，成功则立即处理，nginx停止搜索其他匹配。
^~	用于标准 uri 前，并要求一旦匹配到就会立即处理，不再去匹配其他的那些个正则 uri，一般用来匹配目录
~	用于正则 uri 前，表示 uri 包含正则表达式， 区分大小写
~*	用于正则 uri 前， 表示 uri 包含正则表达式， 不区分大小写
@	”@“ 定义一个命名的 location，@定义的locaiton名字一般用在内部定向，例如error_page, try_files命令中。它的功能类似于编程中的goto。
```

### http 转 https

```conf
server {
    listen       80;
    server_name  me-stg.garys.top;
    rewrite ^(.*)$ https://${server_name}$1 permanent;
}
```

### https配置/单向&&双向

```conf
    server {
        listen       443 ssl;
        server_name  ttt.com;
        ssl                  on;  
        ssl_certificate      /data/sslKey/server-cert.crt;  #server证书公钥
        ssl_certificate_key  /data/sslKey/server-key.key;   #server私钥
        ssl_client_certificate /data/sslKey/root-cert.crt;  #生成client_certificate的公钥
        ssl_verify_client on;  #开启客户端证书验证  

        location / {
            root   html;
            index  index.html index.htm;
        }
    }
```

### IP访问限制

- 可放在 server 内, 或者在 location 内

```conf IP
server {
    listen       80;
    server_name  me-stg.garys.top;
    allow 192.168.0.0/16;
    allow 10.10.0.0/16;
    deny all;
    # deny 8.8.0.0/16;
    location / {
        proxy_pass http://XXX.XXX.XXX.XXX:23456;
    }
}
```

### 速率限制 对整个server生效

```conf
http {
    limit_req_zone $binary_remote_addr zone=one:10m rate=8r/s;
    server {
        ...
        location /search/ {
            limit_req zone=one burst=5;
        }
    }
}
```

### 默认请求的server

http://nginx.org/en/docs/http/request_processing.html
"default_server"参数从0.8.21版开始可用。在之前的版本中，应该使用"default"参数代替。
nginx 的 default_server 指令可以定义默认的 server 去处理一些没有匹配到 server_name 的请求，如果没有显式定义，则会选取第一个定义的 server 作为 default_server。

```conf
server {
    listen       80  default_server; # 
    server_name  _;
    return       200 '请访问garys.top';
}
```

### server 的匹配顺序

Nginx中的server_name指令主要用于配置基于名称的虚拟主机，server_name指令在接到请求后的匹配顺序分别为：

```conf
# 1 准确的server_name匹配，例如：
server {
    listen 80;
    server_name domain.com www.domain.com;
    ...
}
# 2 以通配符开始的字符串：
server {
    listen 80;
    server_name .domain.com;
    ...
}
# 3 以通配符结束的字符串：
server {
    listen 80;
    server_name www.;
    ...
}
# 4 匹配正则表达式：
server {
    listen 80;
    server_name ~^(?.+).domain.com$;
    ...
}
```

### 重定向和跳转

1. 重定向

```conf
server {
    listen 80;
    server_name garys.top;
    location /test {
        rewrite ^(.*)$ http://pornhub.com$request_uri redirect; # 临时重定向 302
        #rewrite ^(.*)$ http://www.driverzeng.com permanent; # 永久重定向 301
    }
}
# last 相当于Apache里的[L]标记，表示完成rewrite
# break 终止匹配, 不再匹配后面的规则
```

2. 跳转

```conf
server {
    listen 80;
    server_name garys.top;
    location /test {
        proxy_pass  http://test.garys.top ; 
    }
}
```

### dns解析

1. Nginx0.6.18以后的版本中启用了一个resolver指令
2. 解决错误 no resolver defined to resolve 或 could not be resolved

```conf
http {
    # 依次从左到右
    resolver 114.114.114 8.8.8.8 valid=3600s;
}
```
