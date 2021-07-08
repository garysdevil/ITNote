# Confluence
- 功能
    - 一个知识管理的工具/收费的
## 安装
- 依赖软件
    - Linux操作系统
    - Java
    - MySQL
    - mysql-connector-java-版本号
    - Confluence

- 默认配置文件
    - /var/atlassian/application-data/confluence/confluence.cfg.xml

- 配置堆内存避免 java.lang.OutOfMemoryError: Java heap space
在JVM中如果98％的时间是用于GC且可用的 Heap size 不足2％的时候将抛出此异常信息

vim atlassian/confluence/bin/setenv.sh
```conf
# 默认为1024m
CATALINA_OPTS="-s4096m -Xmx4096m -XX:+UseG1GC ${CATALINA_OPTS}"
```

# Jira
- 功能
    - 问题跟踪系统，项目管理软件/收费的
## 安装
- 依赖软件
    - Linux操作系统
    - Java
    - MySQL
    - mysql-connector-java-版本号
    - Jira

# xxljob
- 参考
    - https://github.com/xuxueli/xxl-job
## 安装
- 依赖软件
    - Java Jdk1.8+
    - Maven3+
    - Mysql5.7+

- docker方式安装
```bash
# 下载项目源码并解压，然后初始化数据库
/xxl-job/doc/db/tables_xxl_job.sql
# 
docker pull xuxueli/xxl-job-admin:版本号
# 
docker run -e PARAMS="--spring.datasource.url=jdbc:mysql://127.0.0.1:3306/xxl_job?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true&serverTimezone=Asia/Shanghai" -p 8080:8080 -v /tmp:/data/applogs --name xxl-job-admin  -d xuxueli/xxl-job-admin:{指定版本}
# 访问 账户密码 admin/123456
http://127.0.0.1
```