
# Grafana
- 参考
    - 官方文档 https://grafana.com/docs/installation/rpm/
## 安装Grafana
- 默认使用sqlite3 数据库
- 配置文件 /etc/grafana/grafana.ini

- 默认账户密码是 admin/admin
- 默认web端口是 3000
### 通过包管理软件安装
1. Centos7安装Grafana
    ```bash
    echo '[grafana]
    name=grafana
    baseurl=https://packages.grafana.com/oss/rpm
    repo_gpgcheck=1
    enabled=1
    gpgcheck=1
    gpgkey=https://packages.grafana.com/gpg.key
    sslverify=1
    sslcacert=/etc/pki/tls/certs/ca-bundle.crt' > /etc/yum.repos.d/grafana.repo
    yum install grafana -y 

    # 或者
    wget https://dl.grafana.com/oss/release/grafana-7.3.1-1.x86_64.rpm 
    sudo yum install grafana-7.3.1-1.x86_64.rpm 
    ```

2. Ubuntu16安装Grafana
    ```bash
    wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana_4.6.2_amd64.deb
    dpkg -i grafana_4.6.2_amd64.deb
    ```

3. 启动服务
    ```bash
    systemctl start grafana-server
    systemctl enable grafana-server
    # 默认账户密码是 admin/admin
    # 默认web端口是 3000
    ```
### 通过二进制安装
1. 安装
    ```shell
    wget https://dl.grafana.com/oss/release/grafana-7.3.1.linux-amd64.tar.gz
    tar -zxvf grafana-7.3.1.linux-amd64.tar.gz
    mkdir -p /opt/
    tar xzf grafana-6.0.2.linux-amd64.tar.gz -C /opt/
    cd /opt/
    mv grafana-7.3.1 grafana

    # nohup /opt/grafana/bin/grafana-server -config /opt/grafana/conf/defaults.ini -homepath /opt/grafana > /opt/grafana/grafana.log 2>&1 &
    ```
2. 服务化程序
    - vim /usr/lib/systemd/system/grafana-server.service
    ```conf
    [Unit]
    Description=Grafana instance
    Documentation=http://docs.grafana.org
    Wants=network-online.target
    After=network-online.target
    After=postgresql.service mariadb.service mysqld.service

    [Service]
    # EnvironmentFile=/etc/sysconfig/grafana-server # 选定要加载的环境变量文件
    User=grafana
    Group=grafana
    Type=notify
    Restart=on-failure
    WorkingDirectory=/opt/grafana
    RuntimeDirectory=grafana
    RuntimeDirectoryMode=0750

    Environment="CONFFILE=/opt/grafana/conf/defaults.ini test=/tmp"
    ExecStart=/opt/grafana/bin/grafana-server --config $CONFFILE
    LimitNOFILE=10000
    TimeoutStopSec=20

    [Install]
    WantedBy=multi-user.target

    ```
## 使用
### 插件
```bash
# 查找官网所有可用插件
grafana-cli plugins list-remote

# 安装zabbix和prometheus-alertmanager数据源插件
cd /opt/grafana/bin/
./grafana-cli plugins install alexanderzobnin-zabbix-app # 然后 在grafana界面 -> Configuration -> Plguins -> zabbix中启用
./grafana-cli plugins install camptocamp-prometheus-alertmanager-datasource
--pluginsDir= 指定插件安装目录

# 安装 饼状图 插件
./grafana-cli plugins install grafana-piechart-panel 


# 通过下载插件安装包进行安装
https://grafana.com/grafana/plugins/alexanderzobnin-zabbix-app/installation
unzip alexanderzobnin-grafana-zabbix-v3.7.0-0-g1a85503.zip -c /var/lib/grafana/plugins/

# 重启grafana服务
systemctl restart grafana-server

# 在web界面可以查看已安装插件
```

#### 数据源
1. 配置zabbix作为Grafana的数据源
    ```text
    http://XXX.XXX.XXX.XXX/zabbix/api_jsonrpc.php
    http://XXX.XXX.XXX.XXX/api_jsonrpc.php
    ```


## dashboard
### 常用的模版
### prometheus
- mysql
    https://grafana.com/grafana/dashboards/6239
    https://grafana.com/dashboards/7362

- node
    https://grafana.com/grafana/dashboards/1860   Node Exporter Full
    https://grafana.com/grafana/dashboards/11074   Node Exporter for Prometheus Dashboard English Version UPDATE 1102

- docker/pod
    395 
    893

- 集群资源监控：9276

- kube-state-metrics k8s资源对象
    https://grafana.com/grafana/dashboards/13332

## Grafana As Code
- 使用代码生成管理grafana 的 dashboard
https://zhuanlan.zhihu.com/p/61660797
http://dockone.io/article/10655
https://grafana.com/blog/2020/02/26/how-to-configure-grafana-as-code/
https://github.com/alanpeng/grafonnet-lib
https://github.com/prometheus-operator/kube-prometheus/blob/master/docs/developing-prometheus-rules-and-grafana-dashboards.md

- json-model
https://grafana.com/docs/grafana/latest/dashboards/json-model/


## grafana内置函数
https://graphite.readthedocs.io/en/latest/functions.html

asPercent(#B, sumSeries(#A)

## TO-DO
```
模板变量的隐藏玩法
模板变量甚至可以用在 grafana 的跳转中，这是连文档中都没有提及的一个隐藏玩法，在 Link 或者 Dashboard 里 URL 中任意位置填入 $name ，那么在用户点击该链接跳转时 grafana 同样会替换该变量来让你跳到正确的链接去。这和其他系统整合起来能够做到很不错的用户体验，例如跳转到 kibana 那边去查询日志。

kibana 和 grafana 的时间范围格式并不一样，可以使用这篇文章 中的 chrome 插件来解决。

另外，Custom 模板变量可以允许用户在变量下拉框中自行输入值，也是一个经常用到的值，配合模板变量会和当前链接中的 querystring 部分的var-${name} 同步，配合起来可以轻松地从第三方系统中跳转到正确的 grafana 面板中来
```