
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

#是否开启http1.1
proxy_http_version 1.1;
proxy_set_header Connection "";

#转发模块的超时设置 根据需要调整大小
proxy_connect_timeout 30s;
proxy_send_timeout 60s;
proxy_read_timeout 60s;

# 长连接
keepalive_timeout 75s

access_log logs/$host.log main;   //自动根据访问域名生成log


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
yum install httpd-tools -y
2. 创建登入用户
htpasswd -c -d /usr/local/openresty/nginx/conf/pass_file 用户名
3. 配置nginx
```conf
server {
  listen    80; 
  server_name garyss.top;
  auth_basic  "登录认证";
  auth_basic_user_file /usr/local/openresty/nginx/conf/pass_file;
  # proxy_set_header Authorization '';
}
```

## 跨域
```conf
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type');
header('Access-Control-Allow-Methods: POST GET');
header('Access-Control-Max-Age: 1000');

if ($_SERVER['REQUEST_METHOD'] = 'OPTIONS') {
  return;
}
```

## 请求头
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
  1. 编程语言语法错误，web脚本错误
  2. 并发高时，因为系统资源限制，而不能打开过多的文件

2. 502 Bad Gateway错误
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