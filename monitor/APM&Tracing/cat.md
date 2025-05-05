---
created_date: 2021-07-18
---

[TOC]

- 参考
    - https://github.com/dianping/cat/wiki/readme_server
## 安装
1. 依赖
    1. mysql5.7
    2. java1.8
    3. maven3+  如果自己编译cat源码为war包则需要安装
    4. tomcat7
 
### 安装配置tomcat
1. 安装
```bash
yum install tomcat
```
2. 更改tomcat启动参数 vim tomcat/bin/setenv.sh
```bash
export CAT_HOME=/data/appdatas/cat/
# 修改启动参数 java对内存分配
CATALINA_OPTS="$CATALINA_OPTS -server -DCAT_HOME=$CAT_HOME -Djava.awt.headless=true -Xms25G -Xmx25G -XX:PermSize=256m -XX:MaxPermSize=256m -XX:NewSize=10144m -XX:MaxNewSize=10144m -XX:SurvivorRatio=10 -XX:+UseParNewGC -XX:ParallelGCThreads=4 -XX:MaxTenuringThreshold=13 -XX:+UseConcMarkSweepGC -XX:+DisableExplicitGC -XX:+UseCMSInitiatingOccupancyOnly -XX:+ScavengeBeforeFullGC -XX:+UseCMSCompactAtFullCollection -XX:+CMSParallelRemarkEnabled -XX:CMSFullGCsBeforeCompaction=9 -XX:CMSInitiatingOccupancyFraction=60 -XX:+CMSClassUnloadingEnabled -XX:SoftRefLRUPolicyMSPerMB=0 -XX:-ReduceInitialCardMarks -XX:+CMSPermGenSweepingEnabled -XX:CMSInitiatingPermOccupancyFraction=70 -XX:+ExplicitGCInvokesConcurrent -Djava.nio.channels.spi.SelectorProvider=sun.nio.ch.EPollSelectorProvider -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCApplicationConcurrentTime -XX:+PrintHeapAtGC -Xloggc:/data/applogs/heap_trace.txt -XX:-HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/data/applogs/HeapDumpOnOutOfMemoryError -Djava.util.Arrays.useLegacyMergeSort=true"

```
3. 修改中文乱码 vim /usr/share/tomcat/conf/server.xml
```xml
<Connector port="8080" protocol="HTTP/1.1"
           URIEncoding="utf-8"    
           connectionTimeout="20000"
           redirectPort="8443" />  <!-- 增加  URIEncoding="utf-8"  -->  
```

### 配置cat集群  /data/appdatas/cat/
1. 创建
```bash
mkdir -p /data/appdatas/cat/
chmod -R 777 /data/
cd /data/appdatas/cat/
```
2. 数据库配置 vim /data/appdatas/cat/datasources.xml
```xml
<?xml version="1.0" encoding="utf-8"?>

<data-sources>
	<data-source id="cat">
		<maximum-pool-size>3</maximum-pool-size>
		<connection-timeout>1s</connection-timeout>
		<idle-timeout>10m</idle-timeout>
		<statement-cache-size>1000</statement-cache-size>
		<properties>
			<driver>com.mysql.jdbc.Driver</driver>
			<url><![CDATA[jdbc:mysql://127.0.0.1:3306/cat]]></url>  <!-- 请替换为真实数据库URL及Port  -->
			<user>root</user>  <!-- 请替换为真实数据库用户名  -->
			<password>root</password>  <!-- 请替换为真实数据库密码  -->
			<connectionProperties><![CDATA[useUnicode=true&characterEncoding=UTF-8&autoReconnect=true&socketTimeout=120000]]></connectionProperties>
		</properties>
	</data-source>
</data-sources>

```

### cat客户端配置
2. 集群配置 vim client.xml
```xml
<!-- 告诉客户端应该去连接哪个服务端，从哪个服务端里获取配置信息 -->
<?xml version="1.0" encoding="utf-8"?>
<config mode="client">
	<!-- 配置Domain ID，默认为cat -->
    <!-- <domain id="cat" enabled="true" max-message-size="1000"/> -->
    <servers>
        <server ip="IP地址" port="2280" http-port="8080"/>
    </servers>
</config>
```
### 数据库配置 和 配置war包
```bash
git clone https://github.com/dianping/cat.git

# 创建数据库cat和用户cat
mysql -ucat -Dcat -p < script/CatApplication.sql

# 修改系统参数max_allowed_packet为128M并且重启
# [mysqld]
# max_allowed_packet=1000M

# cd cat && mvn clean install -DskipTests
wget http://unidal.org/nexus/service/local/repositories/releases/content/com/dianping/cat/cat-home/3.0.0/cat-home-3.0.0.war

mv cat-home-3.0.0.war car.war

mv car.war /usr/share/tomcat/webapps
```

### 启动 和 访问并且在web界面更改路由策略
```bash
systemctl restart tomcat
systemctl enable tomcat
http://${IP}:8080/cat/s/config?op=routerConfigUpdat/
```

## 问题
1. 报表在小时模式里有数据，但在历史模式下没有数据
	- 在web界面修改服务端配置 
	- job-machine : 定义当前服务是否为报告工作机（开启生成汇总报告和统计报告的任务，只需要一台服务机开启此功能），默认为 false；