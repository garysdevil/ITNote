
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
yum install httpd-tools -y
htpasswd -c -d /usr/local/openresty/nginx/conf/pass_file magina
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

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
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
$request_time 从接受用户请求的第一个字节到发送完响应数据的时间。
$upstream_response_time 从Nginx向后端建立连接开始到接受完数据然后关闭连接为止的时间。

## 变量设置
set $var prod

  map $server_name $domain {
    default airyclub;
    *.floryhub floryhub;
    *.vova vova;
  } 