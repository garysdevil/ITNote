## tokio概览
- tokio 
    - 提供了一个事件驱动型的非阻塞 I/O 异步运行时库(Runtime).
    - 提供了Rust标准库的一些异步版本。

- tokio 基于Rust官方的 Future库 和 MIO库 基础上实现了用户态线程。

- tokio 底层维护着两个线程池
    - Fixed-size threadpool for executors，为tokio::spawn产生的任务服务
    - Bounded threadpool for blocking calls，为tokio::task::spawn_blocking产生的任务服务

- tokio 每创建一个Runtime时，就在这个Runtime中创建好了一个Reactor、一个Scheduler、一个或多个 executor，任务队列。
    - Reactor接收事件通知。 阻塞队列中的每一个被阻塞的任务，都需要等待Reactor收到对应的事件通知(比如IO完成的通知、睡眠完成的通知等)来唤醒它。当该任务被唤醒后，它将被放入就绪队列，等待调度器的调度。
    - Scheduler将就绪队列任务调度给executer。

- 锁
    - 标准库中的锁定策略取决于操作系统的实现
        1. Windows和macOS，读者和作家公平排队。
        2. Linux，读者优先，作家会出现饥饿现象。
    - tokio中的锁定策略是读者和作家公平排队，与操作系统无关。
    - tokio的RwLock在挂起的时候，会让出执行权，标准库的不会。

- Task
    - 每个task占用64 bytes
    - 每个task都必须实现了Send特性，因为task可能会在线程间转移。
    - 执行.await后，task会在线程间转移。
    - task内的数据必须存储在当前task内，当task发生线程间的转移时，会涉及到task内的数据拷贝。
    - task 的类型是 'static 的，因此任务内部的变量不能存在外部引用。

## 相关链接
- 代码仓库 https://github.com/tokio-rs
- 用例示范 https://github.com/tokio-rs/tokio/tree/master/examples
- 官网 https://tokio.rs/
- 教程 https://tokio.rs/tokio


## runtime的创建
```rs
use tokio;
fn main1() {
    // 创建多线程的runtime
    let tokio_rt = tokio::runtime::Runtime::new().unwrap();
}

fn main2() {
    // 创建单一线程的runtime
    let tokio_rt = tokio::runtime::Builder::new_current_thread().build().unwrap();
}

fn main3() {
    // 创建多线程的runtime // 自定义配置
    let tokio_rt = tokio::runtime::Builder::new_multi_thread() // // 使用Runtime Builder来配置并创建runtime
        .worker_threads(8)  // 8个工作线程 // 默认等同于逻辑线程数量
        .enable_io()        // 可在runtime中使用异步IO
        .enable_time()      // 可在runtime中使用异步计时器(timer)
        .build()            // 创建runtime
        .unwrap();
    std::thread::sleep(std::time::Duration::from_secs(10)); // 睡眠，然后执行 ps -ef | grep ${process_name} | grep -v grep | awk '{print $2}' | xargs ps -T -p 查看 程序启动的线程数量
}


// 通过宏来创建runtime 
// 创建多线程的runtime
#[tokio::main]
async fn main() {}

// 创建单一线程的runtime
#[tokio::main(flavor = "current_thread")]
async fn main() {}

// 创建多线程的runtime // 自定义配置
#[tokio::main(flavor = "multi_thread", worker_threads = 10))]
async fn main() {}
```

## CPU-bound tasks
```rs
// 主题： CPU-bound tasks and blocking code

use std::{time::Duration,thread};
#[tokio::main]
async fn main() {
    // 创建一个异步阻塞任务
    let blocking_task1 = tokio::task::spawn_blocking(|| {
        thread::sleep(Duration::from_secs(2));
        println!("111");
    });
    // 创建一个异步阻塞任务 // 创建一个线程
    let blocking_task2 = tokio::task::spawn_blocking(|| {
        println!("222");
    });

    println!("333");
    thread::sleep(Duration::from_secs(2));  // blocking_task1 和 blocking_task2 不会被主线程阻塞
    blocking_task1.await.unwrap(); // 通过 .await 主线程被阻塞，通过 unwrap() blocking_task1 抛出异常则程序终止
    blocking_task2.await.unwrap();
    println!("444");
}
```

## Asynchronous IO
```rs
// 主题： Asynchronous IO

use tokio::net::TcpListener;
use tokio::io::{AsyncReadExt, AsyncWriteExt};

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let listener = TcpListener::bind("127.0.0.1:8080").await?;
    loop {
        let (mut socket, _) = listener.accept().await?; // 阻塞直到被连接
        // tokio 的 tokio::spawn 函数是生成一个任务，然后把任务放进队列里。
        tokio::spawn(async move { 
            let mut buf = [0; 1024];
            // 循环，读取socket的数据，然后写回去
            loop {
                let n = match socket.read(&mut buf).await {
                    // socket closed
                    Ok(n) if n == 0 => return,
                    Ok(n) => n,
                    Err(e) => {
                        eprintln!("failed to read from socket; err = {:?}", e); // 标准错误输出
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
// 主题： block_on 阻塞当前线程
use std::{thread,time::Duration};
use chrono::Local;
use tokio::{self, runtime::Runtime, time};

fn now() -> String {
    Local::now().format("%F %T").to_string()
}

fn fn_name() {
  tokio::spawn(async {
    println!("an async task start at: {}", now());
    time::sleep(time::Duration::from_secs(1)).await; // 不会阻塞主线程
    thread::sleep(Duration::from_secs(1)); // 阻塞主线程
    println!("an async task over at: {}", now());
  });
}

fn main() {
    let rt = Runtime::new().unwrap();
    // block_on() 阻塞主线程
    rt.block_on(async {
      fn_name();
      println!("============{}", now());
    });
    // 睡眠，阻塞主线程结束
    thread::sleep(Duration::from_secs(2));
}
```

```rs
// tokio::spawn 生成一个future，并且在runtime里运行这个future
// async fn 会返回一个future，等待被运行
use std::time::{Duration,Instant};
use std::thread;

fn main() {
    let tokio_rt = tokio::runtime::Runtime::new().unwrap();

    tokio_rt.block_on(async {

        task_1().await; // 运行task_1()，阻塞主线程
        tokio::spawn(task_2()); // 运行task_1()，不阻塞主线程，因此主线可能会先于task_2()结束

        tokio::spawn(async { // 不阻塞主线程，因此主线可能会先结束
            println!("tokio::spawn closure.");
        });

        let handle = tokio::spawn(async { // 不阻塞主线程，因此主线可能会先结束
            println!("tokio::spawn closure, block main thread");
        });
        handle.await.unwrap();  // 阻塞主线程
    });
}
async fn task_1() {
    thread::sleep(Duration::from_secs(1)); // tokio的sleep函数不阻塞主线程
    println!("task_1 async task over: {:?}", Instant::now());
}
async fn task_2() {
    thread::sleep(Duration::from_secs(1));
    println!("task_2 async task over: {:?}", Instant::now());
}
```

## 线程间的消息传递
```rs
// 主题： 线程间的消息传递，4种方式
// use tokio::sync::oneshot; // 一个Sender，一个Receiver，Sender只能发送一次消息。
// use tokio::sync::broadcast; // 多个Sender，多个Receiver，每个Receiver都可以接收到每条消息。
// use tokio::sync::watch; // 一个Sender，多个Receiver，消息不被保存，Receiver只能收到最新的消息。
use tokio::sync::mpsc; // 多个Sender，一个Receiver。 // 是懒加载的
 
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

## tokio::select!
1. 允许同时等待多个异步计算操作，然后当其中一个操作完成时就退出等待。
2. 最多可以支持 64 个分支
3. 能返回一个值。

```rs
use tokio::sync::oneshot;

async fn some_operation()  {
    println!("执行some_operation操作");
}

#[tokio::main]
async fn main() {
    let (mut tx1, mut rx1) = oneshot::channel();
    let (tx2, rx2) = oneshot::channel();
    // rx1.close(); // 主动关闭通道的接收端，会向通道的发送端发送一条关闭消息。
    tokio::spawn(async {
        // 等待 `some_operation` 的完成
        // 或者处理 `oneshot` 的关闭通知
        tokio::select! {
            val = some_operation() => {
                println!("some_operation函数执行完成");
                let _ = tx1.send(val);
            }
            _ = tx1.closed() => { // 收到了发送端发来的关闭信号
                println!("tx1收到通道接收端的关闭信号");
                // `select` 即将结束，此时，正在进行的 `some_operation()` 任务会被取消，任务自动完成，
                // tx1 被释放
            }
        }
    });

    tokio::spawn(async {
        let _ = tx2.send("two");
    });
    tokio::select! {
        val = rx1 => {
            println!("rx1 completed first with {:?}", val);
        }
        val = rx2 => {
            println!("rx2 completed first with {:?}", val);
        }
    }
}
```

```rs
async fn action_1() -> u8{
    11
}
async fn action_2() -> u8{
    22
}
#[tokio::main]
async fn main() {
    let operation_2 = action_2();
    tokio::pin!(operation_2); // 让 operation_2 实现Unpin特征

    let ( tx, mut rx) = tokio::sync::mpsc::channel::<u8>(128);

    tokio::spawn( async move{
        
        std::thread::sleep(std::time::Duration::from_micros(1));
        tx.send(33).await.unwrap();
    });

    loop {
        tokio::select! {
            Some(v) = rx.recv() => {
                println!("{}", v);
                println!{"{}", & operation_2.await} // 如果要在一个引用上使用 .await，那么引用的值就必须是不能移动的或者实现了 Unpin
                break
            },
            v = action_1() => {println!("{}", v);},
            // 22 = &mut operation_2 => {println!("{}", 22); break},
        }
    }
}
```
## async IO
- 案例在myrust仓库内

## Frame
- 通过帧可以将字节流转换成帧组成的流。
- 每个帧就是一个数据单元，例如客户端发送的一次请求就是一个帧。

## 优雅关闭
- 关键点
    1. 找出合适的关闭时机
    2. 通知程序的每一个子部分开始关闭
    3. 在主线程等待各个部分的关闭结果

## async
```rs
// 通过tokio库创建future
async fn do_stuff(i: i32) -> String {
    // do stuff
    format!("This future is created by tokio")
}

// 通过标准库创建future
use std::future::Future;
// the async function above is the same as this:
fn do_stuff(i: i32) -> impl Future<Output = String> {
    async move {
        // do stuff
        fformat!("This future is created by std library")
    }
}
```

## tokio 和 trace
### tokio-console
```conf
tokio = { version = "1", features = ["full", "tracing"] } # 异步运行时库 # 开启 tokio-console 功能，tokio-console 还是一个不稳定的功能，RUSTFLAGS="--cfg tokio_unstable" cargo run
console-subscriber = "0.1.6"
```

```bash
# 本地安装启动 tokio-console
cargo install --locked tokio-console
tokio-console

# 运行rust代码
RUSTFLAGS="--cfg tokio_unstable" cargo run
```

### Integrating with OpenTelemetry
```bash
# 安装启动 Jaeger，一个可视化trace的UI工具
# Jaeger官网 https://www.jaegertracing.io/
docker run -d -p6831:6831/udp -p6832:6832/udp -p16686:16686 -p14268:14268 jaegertracing/all-in-one:latest
```

```toml
opentelemetry = "0.17.0"
tracing-opentelemetry = "0.17.2" 
opentelemetry-jaeger = "0.16.0"
```

```rs
use opentelemetry::global;
use tracing_subscriber::{
    fmt, layer::SubscriberExt, util::SubscriberInitExt,
};

// Allows you to pass along context (i.e., trace IDs) across services
global::set_text_map_propagator(opentelemetry_jaeger::Propagator::new());
// Sets up the machinery needed to export data to Jaeger
// There are other OTel crates that provide pipelines for the vendors
// mentioned earlier.
let tracer = opentelemetry_jaeger::new_pipeline()
    .with_service_name("mini-redis")
    .install_simple()?;

// Create a tracing layer with the configured tracer
let opentelemetry = tracing_opentelemetry::layer().with_tracer(tracer);

// The SubscriberExt and SubscriberInitExt traits are needed to extend the
// Registry to accept `opentelemetry (the OpenTelemetryLayer type).
tracing_subscriber::registry()
    .with(opentelemetry)
    // Continue logging to stdout
    .with(fmt::Layer::default())
    .try_init()?;
```

## 术语
- Yielding  task交出时间片给runtime，task挂起这个task，去运行其它的task

- Actor 一种并发编程模型
    - 参考 https://www.brianstorti.com/the-actor-model/#:~:text=The%20actor%20model%20is%20a,this%20model%20is%20probably%20Erlang%20.
    - 并发编程中的线程间通信
        - 通过消息传递
        - 通过共享内存
    - 共享内存更适合单机多核的并发编程，而且共享带来的问题很多，编程也困难。随着多核时代和分布式系统的到来，共享模型已经不太适合并发编程。
    - Actor模型(Actor model)
        - 是由Carl Hewitt在1973定义， 由Erlang OTP 推广。
        - Actor属于并发组件模型，通过组件方式定义并发编程范式的高级阶段，避免使用者直接接触多线程并发或线程池等基础概念。
        - Actor模型=数据+行为+消息。
        - Actor模型share nothing，所有的线程(或进程)通过消息传递的方式进行合作，这些线程(或进程)称为Actor。

    - Actor模式的应用
        - MapReduce是一种典型的Actor模式
        - Erlang是一种语言级对Actor支持的编程语言
        - Scala也提供了Actor，但是并不是在语言层面支持
        - Java也有第三方的Actor包
        - Go语言channel机制也是一种类Actor模型。
    - tokio库中，通过spawn一个task来管理应用的部分资源，task之间通过channel进行通信。