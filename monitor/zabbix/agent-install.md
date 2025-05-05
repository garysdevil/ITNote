---
created_date: 2022-06-12
---

[TOC]

## 一 Zabbix agent

### 安装zabbix-agent 3.4

```bash
# https://zabbixonly.com/how-to-install-zabbix-agent-3-4/
installInUbuntu18(){
	# 导入zabbix-agent源
	local url="https://repo.zabbix.com/zabbix/3.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.4-1+bionic_all.deb"
	local name="zabbix-release_3.4-1+bionic_all.deb"
	wget  ${url} -O ${name}
	dpkg -i ${name}
	apt update
	# 安装
	apt-get install -y zabbix-agent
}
installInUbuntu16(){
	# 导入zabbix-agent源
	local url="https://repo.zabbix.com/zabbix/3.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.4-1+xenial_all.deb"
	local name="zabbix-release_3.4-1+xenial_all.deb"
	wget  ${url} -O ${name}
	dpkg -i ${name}
	apt update
	# 安装
	apt-get install -y zabbix-agent
}
installInCentos7(){
    rpm -ivh https://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
	yum makecache
    yum install zabbix-agent  -y
}
config(){
    hostName=$1
	severName="XXX.XXX.XXX.XXX"
	configFile="/etc/zabbix/zabbix_agentd.conf"
	# pid
	#sed -i 's/# PidFile=\/tmp\/zabbix_agentd.pid/PidFile=\/var\/log\/zabbix\/zabbix_agentd.pid/' $configFile
	# log
	sed -i 's/LogFile=\/tmp\/zabbix_agentd.log/LogFile=\/var\/log\/zabbix\/zabbix_agentd.log/' $configFile
	# passive mode
	sed -i "s/Server=127.0.0.1/Server=${severName}/"  $configFile
	sed -i 's/ServerActive=127.0.0.1/# &/' $configFile
	sed -i "s/Hostname=Zabbix server/Hostname=${hostName}/" $configFile
    systemctl enable zabbix-agent
}
restart(){
	# /etc/init.d/zabbix-agent start 
	# service zabbix-agent restart
    systemctl restart zabbix-agent
}
init(){
flag=!`systemctl | grep zabbix-agent`
if [ X$flag != X ];then
	clientIP=`ip r | grep 'ens160 proto kernel' | awk  '{print $9}'`
    installInCentos7
    echo 'finish install'
    config $clientIP
    echo 'finish config'
    restart
    echo "finish restart agent - $clientIP"
else
	echo 'has existed zabbix-agent'
fi
}
init
```

## JMX agent

- Zabbix-Java-gateway

- 基于Zabbix 3.4

- 参考

  - https://www.zabbix.com/documentation/3.4/manual/config/items/itemtypes/jmx_monitoring
  - https://www.zabbix.com/documentation/3.4/manual/concepts/java
  - https://www.cnblogs.com/The-day-of-the-wind/p/9360867.html
  - https://my.oschina.net/davehe/blog/520601
  - http://www.361way.com/zabbix-jmx/6044.html

- Zabbix-Java-gateway

  - 从Zabbix 2.0版本起添加的程序，基于Java写的一个程序，用于监控JMX应用程序的服务进程。

- Java 管理扩展（Java Management Extension，JMX）是从jdk1.4开始的，但从1.5时才加到jdk里面，并把API放到java.lang.management包里面，是一个为Java应用程序植入管理功能的框架。

### 安装配置Zabbix-Java-gateway

1. 安装

   - yum -y install zabbix-java-gateway

2. 配置启动zabbix-java-gateway vi /etc/zabbix/zabbix_java_gateway.conf

   ```conf
   LISTEN_IP=”0.0.0.0″
   LISTEN_PORT=10052
   PID_FILE=”/var/run/zabbix/zabbix_java.pid”
   # 开启的工作线程数
   START_POLLERS=5
   ```

   - systemctl start zabbix-java-gateway

3. 配置重启zabbix-server vi /etc/zabbix/zabbix_server.conf

   ```conf
   JavaGateway=172.0.0.1 # JavaGateway的服务器IP地址
   JavaGatewayPort=10052 # JavaGateway的服务端口
   StartJavaPollers=5 # 从javaGateway采集数据的进程数
   ```

   - systemctl restart zabbix-server

### Java程序启动时开启JMX

1. Java程序启动JMX示范

```bash
java \
-Dcom.sun.management.jmxremote \
-Djava.rmi.server.hostname=Tomcat服务器IP默认为本地 \
-Dcom.sun.management.jmxremote.port=12345 \
-Dcom.sun.management.jmxremote.authenticate=false \
-Dcom.sun.management.jmxremote.ssl=false \
-jar 名称.jar
```

2. Java程序启动JMX并且认证加密

```bash
java \
-Djava.rmi.server.hostname=${IP} \
-Dcom.sun.management.jmxremote \
-Dcom.sun.management.jmxremote.port=12345 \
-Dcom.sun.management.jmxremote.authenticate=true \
-Dcom.sun.management.jmxremote.password.file=/data/tools/jdk1.8.0_66/jre/lib/management/jmxremote.password \
-Dcom.sun.management.jmxremote.access.file=/data/tools/jdk1.8.0_66/jre/lib/management/jmxremote.access \

-Dcom.sun.management.jmxremote.ssl=true \
-Djavax.net.ssl.keyStore=$YOUR_KEY_STORE \
-Djavax.net.ssl.keyStorePassword=$YOUR_KEY_STORE_PASSWORD \
-Djavax.net.ssl.trustStore=$YOUR_TRUST_STORE \
-Djavax.net.ssl.trustStorePassword=$YOUR_TRUST_STORE_PASSWORD \
-Dcom.sun.management.jmxremote.ssl.need.client.auth=true \
-jar name.ja
```

- 当JMX启用认证时 Zabbix Web界面的item配置项需要添加用户名和密码。

3. 监控Tomcat
   下载tomcat对应版本的jmx jar包

```bash
cd /App/tomcat/lib
wget http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.33/bin/extras/catalina-jmx-remote.jar
# 该jar包，需要重启tomcat生效。
```

vim /usr/local/tomcat/bin/catalina.sh # 本机tomcat路径

```bash
CATALINA_OPTS="$CATALINA_OPTS
-Dcom.sun.management.jmxremote
-Dcom.sun.management.jmxremote.port=12345
-Dcom.sun.management.jmxremote.authenticate=false
-Dcom.sun.management.jmxremote.ssl=false 
-Djava.rmi.server.hostname=tomcat服务IP"
```

### 连通性测试

```bash
# 下载查询测试JMX的jar包
https://sourceforge.net/projects/jmxcmd/ 

# 格式
java -jar jmxcmd.jar USER:PASS HOST:PORT [BEAN] [COMMAND]

# 简单示范，无认证
java -jar jmxcmd.jar - ${IP}:12345 java.lang:type=Memory NonHeapMemoryUsage
```

## SNMP agent

- https://www.zabbix.com/documentation/3.4/manual/config/items/itemtypes/snmp
- 关于snmp的知识 https://blog.csdn.net/bbwangj/article/details/80981098
