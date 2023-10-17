
- JumpServer
## 概览

- Github  https://github.com/jumpserver
- 官网 飞致云 https://jumpserver.org/
- 文档 https://docs.jumpserver.org/zh/v3/guide/index_description/
- 公司 https://fit2cloud.com/

- 个人博客安装V2版本文档 https://segmentfault.com/a/1190000015086911 

- JumpServer是全球首款开源的堡垒机，是符合 4A 规范的专业运维安全审计系统。
    1. 身份验证 Authentication
    2. 账号管理 Account
    3. 授权控制 Authorization
    4. 安全审计 Audit

- 背景
    - 老广 <广宏伟> JumpServer 创始人
    - JumpServer 发布于 2014 年，此后一直保持着每月更新一个大版的速度持续迭代
    - JumpServer 遵循 GPL v 2.0 开源许可协议
    - JumpServer 开发语言为Python / Django。

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

## 企业版
- 相比 JumpServer 开源版，JumpServer 企业版提供面向企业级应用场景的 X-Pack 增强包，以及高等级的原厂企业级支持服务，有效助力企业快速构建并运营自己的运维安全审计系统。


## 功能
### 控制台
1. 仪表盘

2. 用户管理
    1. 用户列表
    2. 用户组
    3. 角色列表： 定义可以访问JumpServer的哪些功能菜单 （X-Pack）

3. 资产管理
    1. 资产列表： 通过云扫描添加。
    2. 标签列表： 根据需求设置标签。

4. 账号管理
    1. 账号模版： 登记服务器的账号密码。
    2. 账号收集： 收集每台服务器的所有账号。 （X-Pack）
    3. 账号改密： 定期更新每台服务器账号的密钥。 （X-Pack）
    4. 账号备份： 定期备份服务器账号密钥。 （X-Pack）

5. 权限管理
    1. 资产授权： 对用户/用户组和服务器进行关联，默认无关联。
    2. 用户登入： 对用户登入JumpServer的IP和时间段进行限制，默认无限制。
    3. 命令过滤： 禁止在服务器上执行一些指令。
    4. 资产登录： 对用户登入服务器的源IP和时间段进行限制。 （X-Pack）
    5. 连接方式： 对用户登入服务器的连接方式进行限制。 （X-Pack）

### 设置
1. 基本设置
2. 组织管理
3. 消息通知： 配置邮箱服务，短信服务
4. 功能设置
5. 认证设置
6. 组件设置： 组件管理、录像存储、命令存储
7. 远程应用
8. 安全设置： 认证安全、登录限制、密码安全、会话安全
9. 界面设置 （X-Pack）
10. 系统工具
11. 系统任务
12. 许可证