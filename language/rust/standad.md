
[toc]

## 标准库
### env
```rs
// 接收命令行参数
fn read_args() {
    let args = std::env::args();
    for arg in args {
        println!("{}", arg);
    }
}
```
### io
```rs
// 读取命令行输入
fn read_stdin() {
    let mut str_buf = String::new();
    std::io::stdin().read_line(&mut str_buf)
        .expect("Failed to read line.");
    println!("Your input line is \n{}", str_buf);
}
```
### fs
```rs
// 文件读取与写入
use std::fs;
use std::io::prelude::*;
fn file_rw() {
    // fs::write("./text.txt", "I am Gary Adam").unwrap();
    let mut file = fs::File::create("./text.txt").unwrap();
    file.write(b"I am Gary Adam2").unwrap();

    let text = fs::read_to_string("./text.txt").unwrap();
    println!("{}", text);
}
// 文件追加内容
use std::io::prelude::*;
use std::fs::OpenOptions;
// file append
fn main() -> std::io::Result<()> {
    let mut file = OpenOptions::new()
            .append(true).open("text.txt")?;
    file.write(b" I am Gary Adam3")?;
    Ok(())
}
```
### time
```rs
use std::time::{Duration, Instant};
use std::thread;

fn expensive_function() {
    thread::sleep(Duration::from_secs(1));
}

fn main() {
    // std::time::Duration 的使用
    let five_seconds = Duration::from_secs(5);
    assert_eq!(five_seconds, Duration::from_millis(5_000));
    assert_eq!(five_seconds, Duration::from_micros(5_000_000));
    assert_eq!(five_seconds, Duration::from_nanos(5_000_000_000));
    let ten_seconds = Duration::from_secs(10);
    let seven_nanos = Duration::from_nanos(7);
    let total = ten_seconds + seven_nanos;
    assert_eq!(total, Duration::new(10, 7)); // 传入 (秒, 纳秒)


    // 可以通过 time::Instant::elapsed 和 time::Instant::now 输出代码的运行时间
    let start = Instant::now();
    expensive_function();
    let duration = start.elapsed();
    println!("Time elapsed in expensive_function() is: {:?}", duration);
}
```

### thread
```rs
use std::thread;
fn main1() {
    // 创建一个线程
    let thread_handler = thread::spawn(move || {
        println!("I am a new thread.");
    });
    // 等待新建线程执行完成 // join函数使主线程等待子线程结束
    thread_handler.join().unwrap();
}

fn main2() {
    // 创建一个线程，进行定义化，线程名称为 thread1, 堆栈大小为4k
    let thread_handler = thread::Builder::new()
                            .name("thread1".to_string())
                            .stack_size(4*1024*1024).spawn(move || {
        println!("I am thread1.");
    });
    // 等待新创建的线程执行完成
    thread_handler.unwrap().join().unwrap();
}
```

```rs
// 线程通讯： 通过静态变量
use std::thread;
static mut VAR: i32 = 5;
fn main() {
    // 创建一个新线程
    let new_thread = thread::spawn(move|| {
        unsafe {
            println!("static value in new thread: {}", VAR);
            VAR = VAR + 1;
        }
    });
    // 等待新线程先运行
    new_thread.join().unwrap();
    unsafe {
        println!("static value in main thread: {}", VAR);
    }
}
```
```rs
// 线程通讯： 通过共享内存
use std::thread;
use std::sync::Arc;
fn main() {
    let var : Arc<i32> = Arc::new(5);
    let share_var = var.clone();
    // 创建一个新线程
    let new_thread = thread::spawn(move|| {
        println!("share value in new thread: {}, address: {:p}", share_var, &*share_var);
    });
    // 等待新建线程先执行
    new_thread.join().unwrap();
    println!("share value in main thread: {}, address: {:p}", var, &*var);
}
```
```rs
// 线程通讯： 通过通道
use std::sync::mpsc;
use std::thread;
fn main() {
    // 创建一个同步通道
    // let (tx, rx): (mpsc::SyncSender<i32>, mpsc::Receiver<i32>) = mpsc::sync_channel(0); // 同步通道
    let (tx, rx): (mpsc::Sender<i32>, mpsc::Receiver<i32>) = mpsc::channel(); // 异步通道
    // 创建线程用于发送消息
    let new_thread = thread::spawn(move || {
        // 发送一个消息，此处是数字id
        tx.send(99).unwrap();
    });
    // 在主线程中接收子线程发送的消息并输出
    println!("receive {}", rx.recv().unwrap());
    new_thread.join().unwrap();
}
```
```rs
// 线程通讯： 通过通道 // 多个发送者
use std::sync::mpsc;
use std::thread;
use std::time::Duration;

fn main() {
    let (tx, rx) = mpsc::channel();

    let tx1 = tx.clone(); // 创建多个发送者（transmitter）
    thread::spawn(move || {
        let vals = vec![
            String::from("hi"),
            String::from("from"),
            String::from("the"),
            String::from("thread"),
        ];

        for val in vals {
            tx1.send(val).unwrap();
            thread::sleep(Duration::from_secs(1));
        }
    });

    thread::spawn(move || {
        let vals = vec![
            String::from("more"),
            String::from("messages"),
            String::from("for"),
            String::from("you"),
        ];

        for val in vals {
            tx.send(val).unwrap();
            thread::sleep(Duration::from_secs(1));
        }
    });

    for received in rx {
        println!("Got: {}", received);
    }
}
```
### sync
```rust
use std::thread;
use std::time::Duration;
use std::sync::Arc; // 原子引用计数（Arc)类型是一种智能指针，它能够让你以线程安全的方式在线程间共享不可变数据。

fn main() {
    let name_arc1 = Arc::new(String::from("I Love You")); 
    let name_arc2 = Arc::clone(&name_arc1); 
    // move 关键字批准 name_arc2变量的所有权转移进线程。
    // 由于name_arc2的作用域结束，Arc::drop()就被调用了，name_arc1的原子计数减一
    // 如果name_arc1 和 name_arc2 是常规的变量类型，那么引用变量类型 name_arc2 没法传递进线程里，因为 name_arc1 的生命周期可能小于 name_arc2 的生命周期。
    thread::spawn(move || { 
        thread::sleep(Duration::from_secs(1));
        println!("{:?}", *name_arc2);
    });
    
    println!("{:?}", name_arc1); // Arc::drop()就被调用了，name_arc1的原子计数减一，变成0，name_arc1变量数据被清除
} 
```

### net
```rs
// 服务端监听地址端口 // 一个简单的单线程服务器
use std::net::{TcpListener, TcpStream};
use std::io::prelude::*;

fn handle_client(mut stream: TcpStream) {
    println!("One connection established, client is {:?}", stream.peer_addr().unwrap());

    // 处理客户端输入的数据
    let mut buffer = [0; 1024]; // 在栈上声明一个缓冲区
    stream.read(&mut buffer).unwrap(); // 阻塞，等待从连接中获取数据，将数据读取进缓冲区
    println!("Request: {}", String::from_utf8_lossy(&buffer[..])); // 将字节转为字符串，并且输出

    // 返回数据给客户端
    let response = "HTTP/1.1 200 OK\r\n\r\n";
    stream.write(response.as_bytes()).unwrap();
    stream.flush().unwrap();
}

fn main() -> std::io::Result<()> {
    let listener = TcpListener::bind("127.0.0.1:8080")?;

    // accept connections and process them serially
    for stream in listener.incoming() {
        handle_client(stream?);
    }
    Ok(())
}
```

```rs
// 连接服务端
use std::net::{IpAddr, Ipv4Addr, SocketAddr, TcpStream};
use std::io::prelude::*;

fn main() -> std::io::Result<()> {
    let socket = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(127, 0, 0, 1)), 8080);
    // let mut stream = TcpStream::connect("127.0.0.1:8080")?;
    let mut stream = TcpStream::connect(socket)?;

    stream.write(&[1])?; // 写入数据进服务端
    stream.read(&mut [0; 128])?; // 从服务端读取数据
    Ok(())
}

```

### collections
```rs
use std::collections::HashMap;

fn main(){
    let mut letters = HashMap::new();

    for ch in "a short treatise on fungi".chars() {
        let counter = letters.entry(ch).or_insert(0);
        // hashmap_instance.entry() 如果不存在这个健，则向hashmap实例插入kv健值对，并且返回被插入hashmap实例的项
        // .or_insert(0) 如果这个健不不存在值，则向kv健值对插入默认值，并且返回kv健值对值的引用
        
        *counter += 1;
    }
    assert_eq!(letters[&'s'], 2);
    assert_eq!(letters[&'t'], 3);
    assert_eq!(letters[&'u'], 1);
    assert_eq!(letters.get(&'y'), None);
}
```

### std::cell


## 全局作用域标准库
```rust
// Rust 的标准库，有一个 prelude 子模块。 
// prelude 子模块里的模块默认导入程序的整个作作用域，也就是说不再需要使用use进行引用。 
std::marker::{Copy, Send, Sized, Sync}
std::ops::{Drop, Fn, FnMut, FnOnce}
std::mem::drop
std::boxed::Box
std::borrow::ToOwned
std::clone::Clone
std::cmp::{PartialEq, PartialOrd, Eq, Ord}
std::convert::{AsRef, AsMut, Into, From}
std::default::Default
std::iter::{Iterator, Extend, IntoIterator, DoubleEndedIterator, ExactSizeIterator}
std::option::Option::{self, Some, None}
std::result::Result::{self, Ok, Err}
std::slice::SliceConcatExt
std::string::{String, ToString}
std::vec::Vec
```

## 标准库
```rs
fn main{
    let array = [1, 2, 3];
    dbg!((array.iter().any(|&x| x > 0))); // 只要有一个元素满足条件则立刻返回true
}

```

## 宏
1. dbg!() 将结果返回并且输出信息到标准错误输出