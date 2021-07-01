
# jumpserver
- 参考文档
    - https://docs.jumpserver.org/zh/master/
    - https://segmentfault.com/a/1190000015086911 个人博客裸安装文档
- 功能
    - 全球首款开源的堡垒机
## 安装
- 依赖软件
    - Linux操作系统
    - MySQL         3306
    - Redis         6379
    - python3和python虚拟环境
    - Jumpserver    8080
        - 安装依赖 
        - 配置 
        - 启动 ./jumpserver/jms start
        - 通过浏览器访问 http://127.0.0.1:8080 默认账号admin，密码admin

    - coco (ssh server 和 websocket server) 老版本
        - 载入python虚拟环境,下载源码
        - 安装依赖
        - 配置
        - 启动 ./coco/cocod start
        - ssh端口 2222  ws端口5000
        - 通过终端访问
            ```bash 
                ssh admin@${IP} -p2222
            ```
    - koko (ssh server 和 websocket server) 新版本基于go语言重构