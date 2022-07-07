[TOC]
## 常用的宝箱 一
```conf
rand = { version = "0.8.5" } # 随机数功能
```

## 常用的宝箱 二
- 文档搜索 https://docs.rs/${宝箱的名字}

```conf
bincode = "1.2.1" # 序列化与反序列化功能
rust-crypto = "0.2.36" # 各种加密算法功能
serde = { version = "1.0.137", features = ["derive"] } # 通过派生宏给结构体、枚举、联合体提供序列化特征
chrono = { version="0.4.19" } # 时间相关的功能
anyhow = "0.1.0" # 处理异常的功能
clap = { version = "3.1" } # 命令行参数解析功能

criterion = { version = "0.3.5" } # 基准测试工具  文档 https://bheisler.github.io/criterion.rs/book/getting_started.html

clap = { version = "3.1", features = [ "derive" ] } # 命令行参数解析

rocksdb = { version = "0.18.0" } # rocksdb的rust封装，即通过rust调用rocksdb c++ api
num_cpus = { version = "1.13.1" } # 获取服务器上的CPU数量

rayon = { version = "1" } # 将线性计算转为并行计算
tokio = { version = "^1.19.2", features = ["full"] } # 异步运行时库
jsonrpsee = { version = "0.14.0" } # 建立在tokio异步运行时库上的web服务框架
tracing = { version = "0.1.35"  } # 结构化日志

once_cell = { version = "1.12.0"  } # 安全的初始化变量，用来存储堆上的信息，并且具有最多只能赋值一次的特征
```

## rayon

```rs
use rayon::prelude::*;
fn sum_of_squares(input: &[i32]) -> i32 {
    // input.iter() // 使用串形模式 
    input.par_iter() // 使用rayon将串形模式改为并行模式
         .map(|&i| i * i)
         .sum()
}
fn main() {
    // 手动配置 rayon 线程池
    rayon::ThreadPoolBuilder::new()
        .stack_size(8 * 1024 * 1024)
        .num_threads((num_cpus::get() / 2).max(1)) // 设置并行线程数为系统逻辑线程数的一半 // 也可以通过环境变量进行设置RAYON_NUM_THREADS
        .build_global()
        .unwrap();
    dbg!(rayon::current_num_threads()); // 输出线程池最大并行线程数
}
```

## rocksdb
- 默认会创建rocksdb:low 和 rocksdb:high两个线程。

```rs
use rocksdb::{DB};

pub fn main() {
    // NB: db is automatically closed at end of lifetime
    let path = "/Users/gary/git/NOTE/myrust/local_path_for_rocksdb_storage";
    {
        let db = DB::open_default(path).unwrap(); // 连接rocksdb数据库
        db.put(b"my key", b"my value").unwrap(); // 插入一个kv数据

        match db.get(b"my key") {
            Ok(Some(value)) => println!("retrieved value: {}", String::from_utf8(value).unwrap()),
            Ok(None) => println!("value not found"),
            Err(e) => println!("operational problem encountered: {}", e),
        }
        db.delete(b"my key").unwrap(); // 删除一个kv数据
    }
    // DB::destroy(&Options::default(), path).unwrap(); // 删除rocksdb数据库
}

```