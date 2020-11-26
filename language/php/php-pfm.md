# php-fpm
- 参考文档 https://www.cnblogs.com/donghui521/p/10334776.html
## 一 概念
1. php-fpm：在整个网络请求的过程中php是一个cgi程序的角色，采用名为php-fpm的进程管理程序来对这些被请求的php程序进行管理。php-fpm工作原理类似于nginx。默认监听127.0.0.1:9000.

2. 协议
cgi 通用网关协议，最早的协议，不高效。用于在http服务和CGI服务之间传输数据
fastcgi 是一种常驻型CGI服务，相对httpd服务器而言是独立的，php就是这种
scgi 和uwsgi 是新出的一种CGI协议，类似于fastcgi

3. 工作数据流
```
www.example.com        
       |
    Nginx             
       | 路由到www.example.com/index.php
       | 加载nginx的fast-cgi模块                 
       | fast-cgi监听127.0.0.1:9000地址          
       | www.example.com/index.php请求到达127.0.0.1:9000
       |
    php-fpm 监听127.0.0.1:9000
       |
       | php-fpm 接收到请求，启用worker进程处理请求        
       | php-fpm 处理完请求，返回给nginx        
       | nginx 将结果通过http返回给浏览器
```
## 二 yum安装php73-php-fpm
1. 
PHP在 5.3.3 之后已经把php-fpm并入到php的核心代码中了，所以php-fpm不需要单独的下载安装。
要想php支持php-fpm，只需要在编译php源码的时候带上 --enable-fpm。
2. 安装重启
```bash
# 安装 EPEL 源
yum install epel-release
# 安装 REMI 源
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
# 安装php
yum install -y php73-php-fpm php73-php-cli php73-php-bcmath php73-php-gd php73-php-json php73-php-mbstring php73-php-mcrypt php73-php-mysqlnd php73-php-opcache php73-php-pdo php73-php-pecl-crypto php73-php-pecl-mcrypt php73-php-pecl-geoip php73-php-recode php73-php-snmp php73-php-soap php73-php-xml php73-php-ldap
# 设置开机自启
systemctl enable php73-php-fpm
# 启动PHP服务
systemctl start php73-php-fpm

## 通过信号重启
kill -USR2 php-fpm的master进程号 
```
3. 扩展包位置
/opt/rh/rh-php72/root/usr/lib64/php/modules/

3. /etc/opt/remi/php73/php.ini
vim php.ini
```conf  php.ini
php_flag[display_errors] = on # 是否以200状态输出错误日志
```
4. php-fpm.conf
## 三 nginx连接php-fpm配置
```conf
server { 
    listen       80; 
    server_name  localhost; 
    set $project_path /opt/project;
    location ~ \.php$ { 
        root           $project_path; 
        fastcgi_pass   127.0.0.1:9000; 
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;  # fastcgi寻找文件的路径
        include        fastcgi_params; 
    } 
}
```
vim scgi_params 传递给php-fpm的参数
```conf 

fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name; #脚本文件请求的路径
fastcgi_param  QUERY_STRING       $query_string; #请求的参数;如?app=123
fastcgi_param  REQUEST_METHOD     $request_method; #请求的动作(GET,POST)
fastcgi_param  CONTENT_TYPE       $content_type; #请求头中的Content-Type字段
fastcgi_param  CONTENT_LENGTH     $content_length; #请求头中的Content-length字段。
 
fastcgi_param  SCRIPT_NAME        $fastcgi_script_name; #脚本名称 
fastcgi_param  REQUEST_URI        $request_uri; #请求的地址不带参数
fastcgi_param  DOCUMENT_URI       $document_uri; #与$uri相同。 
fastcgi_param  DOCUMENT_ROOT      $document_root; #网站的根目录。在server配置中root指令中指定的值 
fastcgi_param  SERVER_PROTOCOL    $server_protocol; #请求使用的协议，通常是HTTP/1.0或HTTP/1.1。  
 
fastcgi_param  GATEWAY_INTERFACE  CGI/1.1; #cgi 版本
fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version; #nginx 版本号，可修改、隐藏
 
fastcgi_param  REMOTE_ADDR        $remote_addr; #客户端IP
fastcgi_param  REMOTE_PORT        $remote_port; #客户端端口
fastcgi_param  SERVER_ADDR        $server_addr; #服务器IP地址
fastcgi_param  SERVER_PORT        $server_port; #服务器端口
fastcgi_param  SERVER_NAME        $server_name; #服务器名，域名在server配置中指定的server_name
 
# PHP only, required if PHP was built with --enable-force-cgi-redirect
#fastcgi_param  REDIRECT_STATUS    200;

# fastcgi_param  param_name           $param_value; # 可自定义变量
# 在php可打印出上面的服务环境变量
# 如：echo $_SERVER['REMOTE_ADDR']

```