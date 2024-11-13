- 主流 Telegram 格式
    1. Telethon： 最流行。（后缀名：session）
    2. Pyrogram：优雅的库，不过不如Telethon流行。（后缀名：session）
    3. tdata： window下的Telegram客户端的格式。土味技术术语--直登号（一个叫做tdata的目录）
    4. api接码形式：将Telegram的协议（一般是xxxx.session文件）和直登号（windows下的Telegram客户端账号信息）转化为在线的链接接码。 （例如： +12362081371|https://tgapiv2.miha.uk/Lyyer2zs85N8cykb/6d3a2bd7-2055-46f7-a321-f33b530f1891/GetHTML
    5. 密钥：某些软件需要，一般就是telethon和pyrogram的string_session形态。
    6. json：某些软件需要。一般内含上者，或者是暴露出来的auth_key
    7. web_auth_key：web版本的官方telegram客户端的登录方式。一般来说，都是一串”982FA。。。。“的值。可以从session文件中获取auth_key后填写。


- 与 Telegram API 交互的 Python 库
    1. Telethon 是一个纯 Python 库，使用 Telegram 的 MTProto 协议 与 Telegram API 通信。它特别适合需要直接、底层操作 Telegram 用户账户的场景。
    2. Pyrogram 是一个基于 Python 的 Telegram 客户端库，支持 Telegram Bot API 和 MTProto 协议。因此，它可以用于用户账户和 Bot 账户。
    3. Opentele 是一个轻量级的 Python 库，主要用于 Telegram 的 MTProto 协议交互。它的设计目标是快速、高效、简洁，适合轻量级的 Telegram 项目。

- Telegram 目前不允许通过任何脚本、API 或自动化手段来修改 2FA（两步验证）密码。此限制是 Telegram 为确保账户安全而设置的，旨在防止未经授权的访问或恶意脚本篡改账户的安全设置。


- 获取 API ID 和 API Hash
    1. 访问 my.telegram.org 并使用您的 Telegram 账号登录（您将收到一个验证码，输入后即可登录）。
    2. 登录后，点击页面上的 API development tools。
    3. Creating an application 
    4. 提交表单后，页面将显示您的 api_id 和 api_hash

https://github.com/thedemons/opentele/
https://github.com/nicollasm/tdata2session_converter
https://github.com/thaithanhnhat/Telethon_to_Tdata
https://docs.jifengtg.com/functiondescription/xie-yi-hao-zhuan-zhi-deng-hao
https://miha.uk/docs/tutor/telegram-format-convert/
https://www.qunfa.tech/