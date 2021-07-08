# Maven
## 安装
1. 下载
```bash
curl -O http://mirrors.hust.edu.cn/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
tar xzvf apache-maven-3.6.3-bin.tar.gz
```
2. 配置环境变量
vi /etc/profile/maven.sh
```conf
export M2_HOME=/opt/app/apache-maven-3.6.3
export PATH=$PATH:$M2_HOME/bin
```
source /etc/profile
mvn -v

3. 配置 本地仓库存储位置/中央仓库
- conf/settings.xml  
```xml
<localRepository>本地仓库在磁盘中的路径</localRepository>
<mirror>  
    <id>nexus-aliyun</id>  
    <mirrorOf>central</mirrorOf>    
    <name>Nexus aliyun</name>  
    <url>http://maven.aliyun.com/nexus/content/groups/public</url>  
</mirror>
```

## 使用

4. 下载jar包
mvn dependency:get  -DgroupId=junit -DartifactId=junit -Dversion=4.8.2
或	
mvn -f pom.xml dependency:copy-dependencies

浏览项目依赖：
mvn dependency:resolve