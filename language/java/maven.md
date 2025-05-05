---
created_date: 2021-07-09
---

[TOC]

# Maven
## 安装
1. 下载
```bash
# https://maven.apache.org/download.cgi
wget https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.zip
tar xzvf apache-maven-3.6.3-bin.tar.gz
```
2. 配置环境变量
vi /etc/profile/maven.sh
```conf
export M2_HOME=/opt/app/apache-maven-3.8.6
export PATH=$PATH:$M2_HOME/bin
```
```bash
source /etc/profile
mvn -v
```

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

1. 下载jar包
```bash
mvn dependency:get  -DgroupId=junit -DartifactId=junit -Dversion=4.8.2
# 或	
mvn -f pom.xml dependency:copy-dependencies
```

2. 浏览项目依赖
```bash
mvn dependency:resolve
```

3. 完整命令详解
```bash
mvn archetype:create 创建Maven项目
mvn compile 编译源代码
mvn test-compile 编译测试代码
mvn test 运行测试
mvn site 生成项目相关信息的网站
mvn clean 清除项目的生成结果
mvn package 打包项目生成jar/war文件
mvn install 安装jar至本地库
mvn deploy 上传至私服
mvn eclipse:eclipse 生成Eclipse项目文件
mvn ieda:ieda 生成IDEA项目文件
mvn archetype:generate 反向生成maven项目的骨架
mvn -Dtest package 只打包不测试
mvn jar:jar 只打jar包
mvn test -skipping compile -skipping test-compile 只测试不编译也不编译测试
mvn eclipse:clean 清除eclipse的一些系统设置
mvn dependency:list 查看当前项目已被解析的依赖
mvn clean install -U 强制检查更新
mvn source:jar 打包源码
mvn jetty:run 运行项目于jetty上
mvn tomcat:run 运行项目于tomcat上
mvn -e 显示详细错误 信息:
mvn validate 验证工程是否正确，所有需要的资源是否可用
mvn integration-test 在集成测试可以运行的环境中处理和发布包
mvn verify 运行任何检查，验证包是否有效且达到质量标准
mvn generate-sources 产生应用需要的任何额外的源代码
mvn help:describe -Dplugin=help 输出Maven Help插件的信息
mvn help:describe -Dplugin=help -Dfull 输出完整的带有参数的目标列
mvn help:describe -Dplugin=compiler -Dmojo=compile -Dfull 获取单个目标的信息
mvn help:describe -Dplugin=exec -Dfull 列出所有Maven Exec插件可用的目标
mvn help:effective-pom 查看Maven的默认设置
mvn install -X 想要查看完整的依赖踪迹，打开 Maven 的调试标记运行
mvn install assembly:assembly 构建装配Maven Assembly
mvn dependency:resolve 打印已解决依赖的列表
mvn dependency:tree 打印整个依赖树
mvn dependency:sources 获取依赖源代码
-Dmaven.test.skip=true 跳过测试
-Dmaven.tomcat.port=9090 指定端口
-Dmaven.test.failure.ignore=true 忽略测试失败
```

4. 常用打包指令
```bash
mvn clean  install package -Dmaven.test.skip=true #清理之前项目生成结果并构建然后将依赖包安装到本地仓库跳过测试
mvn clean deploy package  -Dmaven.test.skip=true #构建并将依赖放入私有仓库
mvn --settings /data/settings.xml clean package -Dmaven.test.skip=true #指定maven配置文件构建
```