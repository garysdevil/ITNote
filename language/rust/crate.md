[TOC]
## 常用的宝箱
- 文档搜索 https://docs.rs/${宝箱的名字}

```conf
rust-crypto = "0.2.36" # 各种加密算法功能

num_cpus = { version = "1.13.1" } # 获取服务器上的CPU数量
futures-util = { version = "0.3" }  # Combinators and utilities for working with Futures, Streams, Sinks, and the AsyncRead and AsyncWrite traits.
once_cell = { version = "1.12.0"  } # 线程安全的初始化变量，用来存储堆上的信息，并且具有最多只能赋值一次的特征。
criterion = { version = "0.3.5" } # 基准测试工具  文档 https://bheisler.github.io/criterion.rs/book/getting_started.html
backoff = "0.4.0" # 指数级回退和重试机制
bytes = "1.2.1" # 提供高效的字节结构；Buf和BufMut特征。
rusty-hook = "0.11.2" # 可以运行任何脚本的 Git 钩子工具。
serial_test = "0.9.0" # 创建串行的测试
tempfile = "3.3.0" # 创建和管理临时文件
walkdir = "2.3.2" # 递归遍历文件夹

# 时间
time =  { version = "0.3.14", features = ["macros"] } # 关于时间的库
chrono = { version="0.4.19" } # 时间相关的库，基于time 0.1构建更丰富的API。

# 异常处理
thiserror = "1.0.33" # 为 std::error::Error 特征提供了一个更方便的衍生宏。这个库可以让程序员可以更方便地封装自定义错误。
anyhow = { version="1.0.58" } # 基于 std::error::Error 特征对各种错误类型进行了封装。

# 随机数
rand = { version = "0.8.5" } # 随机数生成器
rand_chacha = { version = "0.3.1" } # 使用ChaCha算法的加密安全随机数生成器

# gpu
rust-gpu = { version = "0.1.0" }

# 序列化
bincode = "1.3.3" # 序列化与反序列化功能
serde = { version = "1.0.137", features = ["derive"] } # 通过派生宏给结构体、枚举、联合体提供序列化特征
serde_json = "1.0.85" # 处理Json格式值的序列化

# 数据库
rocksdb = { version = "0.19.0" } # rocksdb的rust封装，即通过rust调用rocksdb c++ api

# 异步编程
futures = { version = "0.3.21" } # 对异步编程的抽象
tokio = { version = "1.21.0", features = ["full"] } # 异步运行时库
tokio-util = { version = "0.7.3" } # tokio的附加工具
tokio-stream = { version = "0.1.9" } # 迭代器，异步版本的std::iter::Iterator特征
jsonrpsee = { version = "0.14.0" } # 建立在tokio异步运行时库上的web服务框架
futures-util = "0.3.21" # Common utilities and extension traits for the futures-rs library.

# web
warp = "0.3.2" # web服务器框架
reqwest = { version = "0.11.11" } # HTTP协议请求库

# 多核编程
rayon = { version = "1.5.3" } # 将线性计算转为并行计算
crossbeam = { version = "0.8" }  # 并发编程工具库。

# 日志
tracing = { version = "0.1.35"  } # 一个范围明确、结构化的日志记录和诊断系统。主要由 spans、events、subscribers 组成，tracing库只实现了spans和events功能。
tracing-subscriber = { version = "0.3.15" } # tracing日志系统的subscribers。
tracing-opentelemetry = { version = "0.17.4"} # 将tracing日志记录进opentelemetry的包
tracing-timing  = { version = "0.6.0"} 

# 终端
structopt = { version = "0.3" } # 命令行参数解析进结构体内。由于 structopt 已经被集成进 clap v3 ，所以 structopt 不再添加新功能，只进行维护操作。
clap = { version = "3.1", features = [ "derive" ] } # 命令行参数解析。
ansi_term = "0.12.1" # 控制终端颜色输出和格式化(不推荐)
colored = "2.0.0" # 控制终端颜色输出(推荐)
crossterm = "0.25.0" # 跨平台的终端操作库，具有监听和控制终端的功能。
tui = "0.19.0" # 用于构建丰富的终端用户界面或仪表板的库。依赖于终端操作库 crossterm 或 termion。

```


### tempfile
 - tempfile() 依赖于操作系统、在文件句柄被关闭后删除临时文件。