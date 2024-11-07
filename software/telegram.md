- 主流 Telegram 格式
    1. Telethon： 最流行。（后缀名：session）
    2. Pyrogram：优雅的库，不过不如Telethon流行。（后缀名：session）
    3. tdata： window下的Telegram客户端的格式。土味技术术语--直登号（一个叫做tdata的目录）
    4. api接码形式：将Telegram的协议（一般是xxxx.session文件）和直登号（windows下的Telegram客户端账号信息）转化为在线的链接接码。 （例如： +12362081371|https://tgapiv2.miha.uk/Lyyer2zs85N8cykb/6d3a2bd7-2055-46f7-a321-f33b530f1891/GetHTML
）
    1. 密钥：某些软件需要，一般就是telethon和pyrogram的string_session形态。
    2. json：某些软件需要。一般内含上者，或者是暴露出来的auth_key
    3. web_auth_key：web版本的官方telegram客户端的登录方式。一般来说，都是一串”982FA。。。。“的值。可以从session文件中获取auth_key后填写。



https://github.com/thedemons/opentele/
https://github.com/nicollasm/tdata2session_converter
https://github.com/thaithanhnhat/Telethon_to_Tdata
https://docs.jifengtg.com/functiondescription/xie-yi-hao-zhuan-zhi-deng-hao
https://miha.uk/docs/tutor/telegram-format-convert/