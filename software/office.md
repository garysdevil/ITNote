# Confluence
- 功能
    - 一个知识管理的工具/收费的
## 安装
- 依赖软件
    - Linux操作系统
    - Java
    - MySQL
    - Confluence
    - mysql-connector-java-版本号

- 默认配置文件
    - /var/atlassian/application-data/confluence/confluence.cfg.xml

# Jira
- 功能
    - 问题跟踪系统，项目管理软件
## 安装
- 依赖软件
    - Linux操作系统
    - Java
    - MySQL
    - mysql-connector-java-版本号
    - Jira

# jumpserver
- 参考文档
    - https://docs.jumpserver.org/zh/master/
    - https://segmentfault.com/a/1190000015086911 个人博客裸安装文档
- 功能
    - 全球首款开源的堡垒机
## 安装
- 依赖软件
    - Linux操作系统
    - python3和python虚拟环境
    - MySQL
    - Redis
    - Nginx
    - Jumpserver
        - 安装依赖 
        - 配置 
        - 启动 jumpserver/jms start

    
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

# apollo
- 参考
    - https://github.com/ctripcorp/apollo
## 安装
- 依赖软件
    - Java JDK 1.8.x
    - Maven
    - Mysql 
    - Apollo

- 裸安装
```bash
# 1. 下载三个安装包解压 adminservice,configservice,portal

# 2. 分别配置3个服务
apollo-adminservice/config/application-github.properties

# 3. 分别启动3个服务
apollo-adminservice/scripts/start.sh

# 4. 访问 账户密码 apollo/admin
http://127.0.0.1:8070
```