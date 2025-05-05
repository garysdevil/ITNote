---
created_date: 2024-11-07
---

[TOC]

# 链接
1. https://github.com/thedemons/opentele/
2. https://github.com/thaithanhnhat/Telethon_to_Tdata
3. https://docs.jifengtg.com/functiondescription/xie-yi-hao-zhuan-zhi-deng-hao
4. https://miha.uk/docs/tutor/telegram-format-convert/
5. https://www.qunfa.tech/


# TG

- Telegram 支持32个设备同时在线----此类技术被称为多点登录技术。

# 开发者
1. API ID：一个唯一的整数标识符，与你的 Telegram 应用程序绑定。
2. API Hash：一个随机生成的字符串，作为你的应用程序的密钥，用于身份验证。

- 获取 API ID 和 API Hash
    1. 访问 my.telegram.org
    2. 使用 Telegram 账号登录（Telegram账户将收到一个验证码，输入后即可登录）。
    3. 登录后，点击页面上的 API development tools。
    4. Creating an application 
    5. 提交表单后，页面将显示您的 api_id 和 api_hash


- 主流 Telegram 登入token格式
    1. Telethon： 最流行。（后缀名：session）
    2. Pyrogram：优雅的库，不过不如Telethon流行。（后缀名：session）
    3. tdata： window下的Telegram客户端的格式。土味技术术语--直登号（一个叫做tdata的目录）
    4. api接码形式：将Telegram的协议（一般是xxxx.session文件）和直登号（windows下的Telegram客户端账号信息）转化为在线的链接接码。 （例如： +12362081322|https://tgapiv2.miha.uk/Lyyer2zs85xxcykb/6d3axxd7-2055-46f7-a321-f33b530xxx/GetHTML
    5. 密钥：某些软件需要，一般就是telethon和pyrogram的string_session形态。
    6. json：某些软件需要。一般内含上者，或者是暴露出来的auth_key
    7. web_auth_key：web版本的官方telegram客户端的登录方式。一般来说，都是一串”982FA。。。。“的值。可以从session文件中获取auth_key后填写。


- 与 Telegram API 交互的 Python 库
    1. Telethon 是一个纯 Python 库，使用 Telegram 的 MTProto 协议 与 Telegram API 通信。它特别适合需要直接、底层操作 Telegram 用户账户的场景。
    2. Pyrogram 是一个基于 Python 的 Telegram 客户端库，支持 Telegram Bot API 和 MTProto 协议。因此，它可以用于用户账户和 Bot 账户。
    3. Opentele 是一个轻量级的 Python 库，主要用于 Telegram 的 MTProto 协议交互。它的设计目标是快速、高效、简洁，适合轻量级的 Telegram 项目。


# 风控和养号
1. 登录频率：多个账户短时间内从同一 IP 或少量 IP 登录，Telegram 可能检测到异常流量，触发限制。
    1. 解决办法：一个IP登入1个或2个TG
2. API 调用频率：每个账户有 API 调用上限（例如每秒请求数）。若超过限制，账户可能被暂时封禁（Flood Wait）。
    1. 解决办法：设置合理的操作间隔。
3. 批量行为一致性：多个账户同时执行相同操作（如群发消息或加群），Telegram 的算法可能识别为自动化行为。
    1. 解决办法：设置合理的操作间隔。
4. IP 和设备指纹：使用相同或少量 IP、代理，或未模拟真实设备指纹，容易被关联并封禁。


- 拉群风控规则
    1. 限制群成员的增长速率，禁止每日新增成员超过200人。
    2. 每日邀请限额的引入，普通用户的限额为100次邀请，而认证用户则为500次。