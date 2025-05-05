---
created_date: 2020-11-16
---

[TOC]

## Centos7安装Zabbix服务
- 参考文档
    - https://www.zabbix.com/documentation/5.0/manual/installation/install_from_packages/rhel_centos 
    - https://www.zabbix.com/download?zabbix=5.0&os_distribution=centos&os_version=7&db=mysql&ws=nginx

- zabbix服务由3个组件组成C
    + 数据库
    + zabbix后端
    + zabbix前端
    + 
-  其它信息
    - In Zabbix 4.4 support for Nginx was added

### 一 安装数据库Mysql
1. 需要安装mysql5.7+
    1. 安装5.6导入zabbix数据库数据时报错
    ```log
    ERROR 1071 (42000) at line 348: Specified key was too long; max key length is 767 bytes
    ```

2. 创建zabbix数据库
    ```sql
    mysql -uroot -p
    password
    mysql> create database zabbix character set utf8 collate utf8_bin;
    mysql> create user zabbix@localhost identified by 'password';
    mysql> grant all privileges on zabbix.* to zabbix@localhost;
    mysql> quit;
    ```

### 二 安装Zabbix后端程序
1. 安装
    ```bash
    # 配置源
    rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
    yum clean all
    # 安装zabbix-server
    yum install zabbix-server-mysql -y
    # 导入数据库
    zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix
    ```

2. 更改配置
    ```bash
    # 添加数据库密码，如果未能成功连接数据库，启动时端口将不会被监听
    vim /etc/zabbix/zabbix_server.conf
    DBPassword=zabbix
    ```

3. 启动
    ```
    systemctl start zabbix-server
    systemctl status zabbix-server
    systemctl enable zabbix-server
    ```


### 四 安装Zabbix前端程序
1. 安装php7.2+

2. 更改php-fpm配置，满足Zabbix前端对php的配置要求 vim php.ini
    ```conf 
    max_execution_time = 300
    max_input_time = 300
    post_max_size = 16M
    date.timezone = Asia/Shanghai

    extension=/opt/remi/php73/root/usr/lib64/php/modules/xmlreader.so
    extension=/opt/remi/php73/root/usr/lib64/php/modules/xmlwriter.so
    extension=/opt/remi/php73/root/usr/lib64/php/modules/ldap.so
    ```

2. 安装Zabbix前端
    ```bash
    yum install centos-release-scl -y

    vim /etc/yum.repos.d/zabbix.repo and enable zabbix-frontend repository.

    yum install zabbix-web-mysql-scl zabbix-nginx-conf-scl -y
    ```
    
3. 安装nginx

4. 配置nginx连接php - 参考 /etc/opt/rh/rh-nginx116/nginx/conf.d/zabbix.conf
```conf
server {
        listen          80;
        server_name     localhost;

        root    /usr/share/zabbix;

        index   index.php;

        location = /favicon.ico {
                log_not_found   off;
        }

        location / {
                try_files       $uri $uri/ =404;
        }

        location /assets {
                access_log      off;
                expires         10d;
        }

        location ~ /\.ht {
                deny            all;
        }

        location ~ /(api\/|conf[^\.]|include|locale) {
                deny            all;
                return          404;
        }

        location ~ [^/]\.php(/|$) {
                fastcgi_pass    unix:/var/opt/rh/rh-php72/run/php-fpm/zabbix.sock;
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_index   index.php;

                fastcgi_param   DOCUMENT_ROOT   /usr/share/zabbix;
                fastcgi_param   SCRIPT_FILENAME /usr/share/zabbix$fastcgi_script_name;
                fastcgi_param   PATH_TRANSLATED /usr/share/zabbix$fastcgi_script_name;

                include fastcgi_params;
                fastcgi_param   QUERY_STRING    $query_string;
                fastcgi_param   REQUEST_METHOD  $request_method;
                fastcgi_param   CONTENT_TYPE    $content_type;
                fastcgi_param   CONTENT_LENGTH  $content_length;

                fastcgi_intercept_errors        on;
                fastcgi_ignore_client_abort     off;
                fastcgi_connect_timeout         60;
                fastcgi_send_timeout            180;
                fastcgi_read_timeout            180;
                fastcgi_buffer_size             128k;
                fastcgi_buffers                 4 256k;
                fastcgi_busy_buffers_size       256k;
                fastcgi_temp_file_write_size    256k;
        }
}

```


5. 打开网页
   - http://IP:PORT
       1. 配置数据库地址
       2. 配置Zabbix server地址
       3. 配置完成后将显示 Configuration file "/etc/zabbix/web/zabbix.conf.php" created.
   - 默认管理员账号密码 Admin/zabbix

### 五 密码重置
1.  
```bash
select userid,alias,passwd from users;
echo -n  admin  | openssl md5
update users set  passwd='21232f297a57a5a743894a0e4a801fc3' where userid = '1';
```
## 容器方式安装
- https://www.zabbix.com/documentation/5.0/manual/installation/containers docker方式
- https://github.com/zabbix/zabbix-docker docker-compose方式

## 安装Zabbix-agent
### 安装

- centos7
    ```bash
    rpm -Uvh https://repo.zabbix.com/zabbix/5.4/rhel/7/x86_64/zabbix-release-5.4-1.el7.noarch.rpm && \
    yum clean all && \
    yum install zabbix-agent -y
    ```

- ubuntu20
    ```bash
    wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+focal_all.deb && \
    dpkg -i zabbix-release_5.0-1+focal_all.deb && \
    apt update && \
    apt install zabbix-agent2 -y
    ```

### 更改配置
- vim /etc/zabbix/zabbix_agentd.conf
- vim /etc/zabbix/zabbix_agent2.conf
```conf
Server=127.0.0.1 # 与web端host配置的的接口地址对应
ServerActive=127.0.0.1 # 与web端host配置的的接口地址对应
Hostname=XXX # 与web端host配置的的Name对应
```

