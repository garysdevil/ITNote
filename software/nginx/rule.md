1. 路径规则
```
空	location后没有参数直接跟着URI，表示前缀匹配，代表跟请求中的URI从头开始匹配。
=	用于标准 uri 前，要求请求字符串与其严格匹配，成功则立即处理，nginx停止搜索其他匹配。
^~	用于标准 uri 前，并要求一旦匹配到就会立即处理，不再去匹配其他的那些个正则 uri，一般用来匹配目录
~	用于正则 uri 前，表示 uri 包含正则表达式， 区分大小写
~*	用于正则 uri 前， 表示 uri 包含正则表达式， 不区分大小写
@	”@“ 定义一个命名的 location，@定义的locaiton名字一般用在内部定向，例如error_page, try_files命令中。它的功能类似于编程中的goto。
```

2. http 转 https
```conf
server {
    listen       80;
    server_name  me-stg.garys.top;
    rewrite ^(.*)$ https://${server_name}$1 permanent;
}
```

3. https配置/单向&&双向
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

4. IP访问限制
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

5. 速率限制 对整个server生效
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


6. 默认请求地址
http://nginx.org/en/docs/http/request_processing.html
"default_server"参数从0.8.21版开始可用。在之前的版本中，应该使用"default"参数代替。
nginx 的 default_server 指令可以定义默认的 server 去处理一些没有匹配到 server_name 的请求，如果没有显式定义，则会选取第一个定义的 server 作为 default_server。
```conf
server {
    listen       80  default_server; # 
    server_name  _;
    return       444;
}
```
7. server 的匹配顺序
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