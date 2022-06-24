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
serde = { version = "1.0.137", features = ["derive"] } # 通过派生宏给结构体、枚举、联合体提供序列化特性
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
tracing = { ersion = "0.1.35"  } # 结构化日志
```

## tokio
- tokio 提供了一个事件驱动型的非阻塞 I/O 异步运行时库(Runtime).
- tokio 基于Rust官方的 Future库 和 MIO库 基础上实现了用户态线程。

- tokio 底层维护着两个线程池
    - Fixed-size threadpool for executors，为tokio::spawn产生的任务服务
    - Bounded threadpool for blocking calls，为tokio::task::spawn_blocking产生的任务服务

- tokio 每创建一个Runtime时，就在这个Runtime中创建好了一个Reactor、一个Scheduler、一个任务队列。
    - Reactor接收事件通知。
    - Scheduler将任务调度给executer。

```rs
// 主题： runtime的创建

use tokio;
fn main1() {
    // 创建多线程的runtime
    let rt = tokio::runtime::Runtime::new().unwrap();
    std::thread::sleep(std::time::Duration::from_secs(10)); // 睡眠，然后执行 ps -ef | grep ${process_name} | grep -v grep | awk '{print $2}' | xargs ps -T -p 查看 程序启动的线程数量
}

fn main2() {
    // 创建多线程的runtime // 自定义配置
    let rt = tokio::runtime::Builder::new_multi_thread() // // 使用Runtime Builder来配置并创建runtime
        .worker_threads(8)  // 8个工作线程 // 默认等同于逻辑线程数量
        .enable_io()        // 可在runtime中使用异步IO
        .enable_time()      // 可在runtime中使用异步计时器(timer)
        .build()            // 创建runtime
        .unwrap();
}

fn main3() {
    // 创建单一线程的runtime
    let rt = tokio::runtime::Builder::new_current_thread().build().unwrap();
}

// 通过宏来创建runtime
#[tokio::main]
async fn main() {}

#[tokio::main(flavor = "multi_thread", worker_threads = 10))]
async fn main() {}

#[tokio::main(flavor = "current_thread")]
async fn main() {}
```

```rs
// 主题： CPU-bound tasks and blocking code

use std::{time::Duration,thread};
#[tokio::main]
async fn main() {

    // 运行一个异步阻塞线程
    let blocking_task1 = tokio::task::spawn_blocking(|| {
        thread::sleep(Duration::from_secs(2));
        println!("111");
    });
    // 运行一个阻塞线程
    let blocking_task2 = tokio::task::spawn_blocking(|| {
        thread::sleep(Duration::from_secs(1)); 
        println!("222");
    });

    println!("333");
    thread::sleep(Duration::from_secs(2));  // blocking_task1 和 blocking_task2 不会被主线程阻塞
    blocking_task1.await.unwrap(); // 主线程被阻塞，blocking_task1 抛出异常则程序终止
    blocking_task2.await.unwrap(); // 主线程被阻塞，blocking_task2 抛出异常则程序终止
    println!("444");
}
```

```rs
// 主题： Asynchronous IO

use tokio::net::TcpListener;
use tokio::io::{AsyncReadExt, AsyncWriteExt};

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let listener = TcpListener::bind("127.0.0.1:8080").await?;
    loop {
        let (mut socket, _) = listener.accept().await?;
        // tokio 的 tokio::spawn 函数把任务分派给运行时。下面的代码片段会生成一个任务，tokio把它推入其中一个执行器的任务队列中。
        // 如果没有使用 spawn，所有任务都会分配到同一个处理器上，并且在同一个线程上执行。
        tokio::spawn(async move { 
            let mut buf = [0; 1024];

            // 循环，读取socket的数据，然后写回去
            loop {
                let n = match socket.read(&mut buf).await {
                    // socket closed
                    Ok(n) if n == 0 => return,
                    Ok(n) => n,
                    Err(e) => {
                        eprintln!("failed to read from socket; err = {:?}", e);
                        return;
                    }
                };

                // Write the data back
                if let Err(e) = socket.write_all(&buf[0..n]).await {
                    eprintln!("failed to write to socket; err = {:?}", e);
                    return;
                }
            }
        });
    }
}
```

```rs
// 主题： block_on 阻塞当前线程，运行future(异步线程)

use std::{thread,time::Duration};
use chrono::Local;
use tokio::{self, runtime::Runtime, time};

fn now() -> String {
    Local::now().format("%F %T").to_string()
}

// 在runtime外部定义一个异步任务，且该函数返回值不是Future类型
fn async_task() {
  println!("create an async task: {}", now());
  tokio::spawn(async {
    time::sleep(time::Duration::from_secs(1)).await;
    println!("async task over: {}", now());
  });
}

fn main() {
    let rt1 = Runtime::new().unwrap();
    rt1.block_on(async {
      // 调用函数，该函数内创建了一个异步任务，将在当前runtime内执行
      async_task();
      println!("-----{}", now());
    });
    // 睡眠，阻塞主线程结束
    thread::sleep(Duration::from_secs(2));
}
```

```rs
// 主题： 线程间的消息传递
// use tokio::sync::oneshot; // 一个Sender，一个Receiver，Sender只能发送一次消息。通过同步的方式。
use tokio::sync::mpsc; // 可以有多个Sender，一个Receiver，Sender可以发送多次消息。通过同步的方式。
 
#[tokio::main]
async fn main() {
    let (tx, mut rx) = mpsc::channel(32);
    let tx2 = tx.clone(); //clone之后可以将channel指派给不同任务
 
    tokio::spawn(async move {
        tx.send("sending from first handle").await; //必须调用await才会执行
 
    });

    tokio::spawn(async move {
        tx2.send("sending from second handle").await;
    });
 
    while let Some(message) = rx.recv().await {
        println!("GOT = {}", message);
    }
}
```

## rayon

```rs
use rayon::prelude::*;
fn sum_of_squares(input: &[i32]) -> i32 {
    input.iter() // 使用串形模式 
    // input.par_iter() // 使用rayon将串形模式改为并行模式
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