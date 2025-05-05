---
created_date: 2020-11-16
---

[TOC]

## 编译安装

```bash
wget  https://nginx.org/download/nginx-1.14.2.tar.gz
git clone git://github.com/vozlt/nginx-module-vts.git
useradd nginx
安装c++编译环境

./configure --prefix=/opt/nginx \
--user=nginx --group=nginx \
--with-file-aio \
--with-http_realip_module \
--with-http_auth_request_module \
--with-http_stub_status_module \
--with-pcre \
--with-stream \
--with-stream_ssl_module \
--with-http_v2_module \
--with-http_ssl_module \
--with-http_gzip_static_module \
--with-debug \
--with-http_geoip_module=dynamic \
--add-module=/path/to/nginx-module-vts(根据下载路径自行修改)
```

- 编译好的安装包 nginx.conf.tar.gz

## 关键配置说明

```conf
client_max_body_size 10m;         //请求体大小，一般上传文件比较大时会调整
proxy_set_header Host $http_host;   //后端代理ingress时必填
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;   //影响后端能否获取真实客户端ip

# 自动根据访问域名和端口号生成日志文件
access_log logs/${host}-${server_port}.log main;

#是否开启http1.1
proxy_http_version 1.1;
proxy_set_header Connection "";

# 长连接 指定每个 TCP 连接最多可以保持多长时间 # Nginx 的默认值是 75 秒 # ws代理时需要设置，否则连接会会断开
keepalive_timeout 75s;

# 转发模块的超时设置 根据需要调整大小。ws代理时需要设置，否则连接会会断开
proxy_connect_timeout 30s; # 后端服务器连接的超时时间_发起握手等候响应超时时间
proxy_send_timeout 60s; # 后端服务器数据回传时间_就是在规定时间之内后端服务器必须传完所有的数据.
proxy_read_timeout 60s; # 连接成功后_等候后端服务器响应时间_其实已经进入后端的排队之中等候处理（也可以说是后端服务器处理请求的时间）.

# ws代理，需要在每层反向代理上添加如下信息
proxy_http_version 1.1;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection "upgrade";
```

## 原理

- 参考 https://www.cnblogs.com/yblackd/p/12194143.html

1. 工作模式
   - Nginx 采用的是多进程（单线程） & 多路IO复用模型。
   - 多进程的工作模式
     1. Nginx 在启动后，会有一个 master 进程和多个相互独立的 worker 进程。
     2. 接收来自外界的信号，向各worker进程发送信号，每个进程都有可能来处理这个连接。
     3. master 进程能监控 worker 进程的运行状态，当 worker 进程退出后(异常情况下)，会自动启动新的 worker 进程。

## Web缓存

1. 客户端在请求一个文件的时候，发现自己缓存的文件有 Last Modified ，那么在请求中会包含 If Modified Since ，这个时间就是缓存文件的 Last Modified 。因此，如果请求中包含 If Modified Since，就说明已经有缓存在客户端。服务端只要判断这个时间和当前请求的文件的修改时间就可以确定是返回 304 还是 200 。
2. 缓存Head https://www.cnblogs.com/everyone/archive/2012/12/04/2801258.html

## 基本的http权限认证

1. 按照相关工具

```bash
yum install httpd-tools -y 
# 或者
apt-get install apache2-utils -y
```

2. 创建登入用户
   htpasswd -c -d /etc/nginx/conf.d/.auth 用户名
3. 配置nginx

```conf
server {
    listen    80; 
    server_name garyss.top;
    auth_basic  "登录认证";
    auth_basic_user_file /etc/nginx/conf.d/.auth; // nginx端做认证

    ; proxy_hide_header WWW-Authenticate; //隐藏发给用户的认证http header，相当于不提示用户输用户名密码了。
    ; proxy_set_header Authorization “Basic dXNlcjpwYXNzd29yZA==”; //发送httpd 认证 header给后端服务器。
    location / {
        proxy_set_header Authorization ''; // nginx的后端服务不需要做认证
    }
}
```

## 跨域

```conf
add_header Access-Control-Allow-Origin *;
add_header Access-Control-Allow-Methods 'GET,POST,PUT,DELETE,PATCH,OPTIONS';
add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization';
if ($request_method = 'OPTIONS') {
    return 204;
}
location / {  
    # proxy_hide_header Access-Control-Allow-Origin; # 当后端服务已经配置跨域的时候，nginx需要过滤掉此header信息
    proxy_pass http://127.0.0.1:8545;
} 
```

- 当Nginx和服务端同时设置了跨域的时候，游览器会报如下错。
  - 意思是设置了2次跨域，但是只有一个是允许的，移除其中的任意一个或者在在nginx里进行相关的配置 proxy_hide_header Access-Control-Allow-Origin;
  ```log
  The 'Access-Control-Allow-Origin' header contains multiple values '*, *', but only one is allowed. Have the server send the header with a valid value, or, if an opaque response serves your needs, set the request's mode to 'no-cors' to fetch the resource with CORS disabled.
  ```

## 添加请求头

```conf
location dist/ {
	add_header Cache-Control 'public, max-age=3600';
}

```

## 日志讲解

- https://www.cnblogs.com/Dy1an/p/11232207.html

1.

$request_time 从接受用户请求的第一个字节到发送完响应数据的时间。
$upstream_response_time 从Nginx向后端建立连接开始到接受完数据然后关闭连接为止的时间。

2.

```conf
error_log  logs/error.log  error; # 默认值
# error_log    <FILE>    <LEVEL>;
# [debug | info | notice | warn | error | crit | alert | emerg]

log_not_found on # | off; # 是否在 error_log 中记录不存在的错误，默认 on
```

## 变量设置

1. 方式一
   set $var prod

2. 方式二

```conf
  # map 必须写在 server{} 的外部
  # 设置变量domain，根据内置变量$server_name的匹配情况，设置domain为不同的值
  map $server_name $domain {
    default xxx;
    *.yyy yyy;
    *.zzz zzz;
  } 
```

## 4xx返回码

1. 499

- Client Closed Request，服务端还没有返回给客户端，客户端主动关闭连接，nginx就会记录499。

1. 例如aws ELB的超时时间为120s，当请求时间超过120s时，ELB就会断开和服务端的连接。

## 5xx返回码

- 参考
  - https://www.cnblogs.com/rxbook/p/9198152.html
  - https://www.bnxb.com/nginx/27539.html

1. 500 一般是服务器遇到意外情况，而无法完成请求

2. 编程语言语法错误，web脚本错误

3. 并发高时，因为系统资源限制，而不能打开过多的文件

4. 502 Bad Gateway错误

- 502 是指请求的php-fpm已经执行，但是由于某种原因而没有执行完毕，最终导致php-fpm 进程终止。 可能与php-fpm.conf的配置有关。

3. 504 Gateway timeout 网关超时

- 504 表示超时，也就是客服端所发出的请求没有到达网关，请求没有到可以执行的php-fpm。 可能与nginx.conf的配置有关，也可能是php-cgi进程不够。
- nginx.conf

```conf
http {
  # 减少fastcgi的请求次数，尽量维持buffers不变
  fastcgi_buffer_size 128k; # default 64k
  fastcgi_buffers 4 256k; # default 4 64k
  fastcgi_busy_buffers_size 256k; # default 128k
  fastcgi_temp_file_write_size 256k; # default 128k
}
```

- php 配置

```conf
pm.max_children 30; default 10. 保证有充足的php-cgi进程可以被使用
```

3. 501 服务器无法识别请求方法时可能会返回此代码

4. 503 服务器目前无法使用，通常，这只是暂时状态

5. 505 服务器不支持请求中所有的http协议版本
