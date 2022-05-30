[TOC]
## 常用的宝箱
- 文档搜索 https://docs.rs/${宝箱的名字}

```conf
bincode = "1.2.1" # 提供序列化与反序列化功能
rust-crypto = "0.2.36" # 提供各种加密算法功能
serde = { version = "1.0.137", features = ["derive"] } # 通过派生宏给结构体、枚举、联合体提供序列化特性
chrono = "0.4.19" # 提供各种时间相关的功能
anyhow = "0.1.0" # 处理错误的
clap = { version = "3.1" } # 命令行参数解析功能
```