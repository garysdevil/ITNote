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
### 配置文件
1. tomcat配置文件 atlassian/confluence-6.9/conf/server.xml
    ```xml
    <!-- 端口配置 -->
    <Connector port="8090" connectionTimeout="20000" redirectPort="8443"
                maxThreads="48" minSpareThreads="10"
                enableLookups="false" acceptCount="10" debug="0" URIEncoding="UTF-8"
                protocol="org.apache.coyote.http11.Http11NioProtocol"
                proxyName="confluence.garys.top" proxyPort="80" scheme="http"/>
    <!-- 源码路径配置 -->
    <Context path="" docBase="../confluence" debug="0" reloadable="false" useHttpOnly="true">
    ```
2. 数据路径配置文件 atlassian/confluence-6.9/confluence/WEB-INF/classes/confluence-init.properties
    ```conf
    # 存放confluence运行过程中产生的数据，如用户上传的附件。
    confluence.home = /var/atlassian/application-data/confluence
    ```
3. 数据库配置文件 /var/atlassian/application-data/confluence/confluence.cfg.xml
    ```xml
    <property name="hibernate.connection.password">username</property>
    <property name="hibernate.connection.url">jdbc:mysql://localhost/confluence</property>
    <property name="hibernate.connection.username">password</property>
    ```
4. java启动参数配置文件 atlassian/confluence-6.9/bin/setenv.sh
    ```conf
    # 在JVM中如果98％的时间是用于GC且可用的 Heap size 不足2％的时候将抛出java.lang.OutOfMemoryError: Java heap space异常信息
    # 默认为1024m
    CATALINA_OPTS="-s4096m -Xmx4096m -XX:+UseG1GC ${CATALINA_OPTS}"
    ```
5. 启动 
    ```bash 
    # 测试是否有报错
    ./atlassian/confluence-6.9/bin/configtest.sh 
    # 启动
    ./atlassian/confluence-6.9/bin/startup.sh
    ```

## 插件
1. confluence 统计页面访问量插件Page View Tracker --免费
    - https://marketplace.atlassian.com/plugins/net.kentcom.page-view-tracker/server/overview

## 报错与解决
### Confluence最近更新不显示最近更新的内容/内容页面权限限制无法使用
- 报错日志${confluence.home}/atlassian-confluence.log
    ```log
    2021-07-29 16:04:25,446 ERROR [Caesium-1-4] [impl.schedule.caesium.JobRunnerWrapper] runJob Scheduled job com.atlassian.confluence.plugins.confluence-edge-index:flushEdgeIndexQueueJob#flushEdgeIndexQueue failed to run
    com.atlassian.bonnie.LuceneException: com.atlassian.confluence.api.service.exceptions.ServiceException: Failed to process entries
    ...
    ...
    Caused by: org.springframework.dao.DataAccessResourceFailureException: Failed to read id for journal 'edge_index': null; nested exception is java.lang.NumberFormatException: null
        at com.atlassian.confluence.impl.journal.FilesystemJournalStateStore.getMostRecentId(FilesystemJournalStateStore.java:47)
        at com.atlassian.confluence.impl.journal.CachingJournalStateStore.lambda$getMostRecentId$0(CachingJournalStateStore.java:27)
        at com.atlassian.vcache.internal.core.metrics.TimedSupplier.get(TimedSupplier.java:32)
        at com.atlassian.vcache.internal.legacy.LegacyJvmCache.lambda$get$4(LegacyJvmCache.java:52)
        at java.util.Optional.orElseGet(Optional.java:267)
        at com.atlassian.vcache.internal.legacy.LegacyJvmCache.get(LegacyJvmCache.java:50)
        at com.atlassian.vcache.internal.core.metrics.TimedLocalCacheOperations.get(TimedLocalCacheOperations.java:64)
        at com.atlassian.confluence.impl.journal.CachingJournalStateStore.getMostRecentId(CachingJournalStateStore.java:27)
        at com.atlassian.confluence.impl.journal.DefaultJournalManager.processEntries(DefaultJournalManager.java:79)
        at com.atlassian.confluence.impl.journal.DefaultJournalService.processEntries(DefaultJournalService.java:41)
        ... 75 more
    Caused by: java.lang.NumberFormatException: null
        at java.lang.Long.parseLong(Long.java:552)
        at java.lang.Long.parseLong(Long.java:631)
        at com.atlassian.confluence.impl.journal.FilesystemJournalStateStore.getMostRecentId(FilesystemJournalStateStore.java:44)
        ... 84 more
    ```
- 刷新边际索引队列（Flush Edge Index Queue），能够保证 Confluence 的索引是最新的索引。 每个节点每30s自动执行一次。

- 解决办法  重建索引
    ```bash
    # 参考 https://confluence.atlassian.com/confkb/how-to-rebuild-the-content-indexes-from-scratch-on-confluence-server-110035351.html
    在web界面进入一般配置，点击搜索索引，重构索引。
    停止 confluence
    cd ${confluence.home} && mv journal  journal.bak
    启动 confluence
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