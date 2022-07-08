## tokio概览
- tokio 提供了一个事件驱动型的非阻塞 I/O 异步运行时库(Runtime).
- tokio 基于Rust官方的 Future库 和 MIO库 基础上实现了用户态线程。

- tokio 底层维护着两个线程池
    - Fixed-size threadpool for executors，为tokio::spawn产生的任务服务
    - Bounded threadpool for blocking calls，为tokio::task::spawn_blocking产生的任务服务

- tokio 每创建一个Runtime时，就在这个Runtime中创建好了一个Reactor、一个Scheduler、任务队列。
    - Reactor接收事件通知。 阻塞队列中的每一个被阻塞的任务，都需要等待Reactor收到对应的事件通知(比如IO完成的通知、睡眠完成的通知等)来唤醒它。当该任务被唤醒后，它将被放入就绪队列，等待调度器的调度。
    - Scheduler将就绪队列任务调度给executer。

- 锁
    - 标准库中的锁定策略取决于操作系统的实现
        1. Windows和macOS，读者和作家公平排队。
        2. Linux，读者优先，作家会出现饥饿现象。
    - tokio中的锁定策略是读者和作家公平排队，与操作系统无关。
    - tokio的RwLock在挂起的时候，会让出执行权，标准库的不会。

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
#[tokio::main]
async fn main() {}

#[tokio::main(flavor = "multi_thread", worker_threads = 10))]
async fn main() {}

#[tokio::main(flavor = "current_thread")]
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
// 主题： block_on 阻塞当前线程，运行future
use std::{thread,time::Duration};
use chrono::Local;
use tokio::{self, runtime::Runtime, time};

fn now() -> String {
    Local::now().format("%F %T").to_string()
}

fn fn_name() {
  tokio::spawn(async {
    println!("an async task start at: {}", now());
    time::sleep(time::Duration::from_secs(1)).await;
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
    thread::sleep(Duration::from_secs(1));
    println!("task_1 async task over: {:?}", Instant::now());
}
async fn task_2() {
    thread::sleep(Duration::from_secs(1));
    println!("task_2 async task over: {:?}", Instant::now());
}
```

## 线程间的消息传递
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

## tokio::select!
```rs
// tokio::select! 
// 同时等待多个异步操作的结果，并且对其结果进行进一步处理
// 任何一个 select 分支完成后，都会继续执行后面的代码，没被执行的分支会被丢弃

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