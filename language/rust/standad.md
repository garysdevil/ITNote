
[toc]

## 全局作用域的标准库
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

## 标准库 基本
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

```rs
// Sink.write() 会消耗所有的数据，类似读于把所有数据写入 /dev/null
use std::io::{self, Write};
fn read_stdin() {
    let buffer = vec![1, 2, 3, 5, 8];
    let num_bytes = io::sink().write(&buffer).unwrap();
    assert_eq!(num_bytes, 5);
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

### cell
- 内部可变性智能指针。
- 来源
    - Rust 通过其所有权机制，严格控制拥有和借用关系，来保证程序的安全，并且这种安全是在编译期可计算、可预测的。但是这种严格的控制，有时也会带来灵活性的丧失，有的场景下甚至还满足不了需求。
    - Rust 标准库中，设计了这样一个系统的组件 ``Cell 和 RefCell``,它们弥补了 Rust 所有权机制在灵活性上和某些场景下的不足。同时，又没有打破 Rust 的核心设计。它们的出现，使得 Rust 革命性的语言理论设计更加完整，更加实用。
- Rust 机制里修改一个值，必须是值的拥有者，并且声明 mut；或 以 &mut 的形式，借用。而通过 Cell, RefCell，则可以在需要的时候，就可以修改里面的对象。而不受编译期静态借用规则束缚。
- Cell 和 RefCell 的区别
    - Cell只能包装拥有Copy特征的类型。
    - RefCell能够包装任何类型。

```rs
use std::cell::Cell;

struct SomeStruct {
    regular_field: u8,
    special_field: Cell<u8>,
}

let my_struct = SomeStruct {
    regular_field: 0,
    special_field: Cell::new(1),
};

let new_value = 100;

// ERROR: `my_struct` is immutable
// my_struct.regular_field = new_value;

// WORKS: although `my_struct` is immutable, `special_field` is a `Cell`,
// which can always be mutated
my_struct.special_field.set(new_value);
assert_eq!(my_struct.special_field.get(), new_value);
```

### td::hash
```rs
pub fn main() {
    use std::collections::hash_map::DefaultHasher;
    use std::hash::{Hash, Hasher};
    
    let mut hasher = DefaultHasher::new();
    "eee".hash(&mut hasher);
    println!("Hash is {:x}!", hasher.finish());
}
```


## 标准库 多线程
### thread
```rs
// 启动线程
use std::thread;
fn main() {
    // 启动一个线程
    let thread_handler_1 = thread::spawn(move || {
        thread::yield_now(); // 放弃CPU时间片给操作系统调度器
        println!("I am a new thread thread_handler_1.");
    });
    // 启动一个线程，自定义线程配置。线程名称为 thread_2, 栈大小为4MB // 默认栈大小为2MB
    let thread_handler_2 = thread::Builder::new()
                            .name("thread_2".to_string())
                            .stack_size(4*1024*1024).spawn(move || {
        println!("I am a new thread thread_handler_2.");
    });

    // join函数使主线程挂起等待子线程结束。
    thread_handler_1.join().unwrap();
    if let Ok(thread_handler) = thread_handler_2{
        thread_handler.join().unwrap();
    }
}
```

```rs
// 线程间通讯： 通过静态变量
use std::thread;
static mut VAR: i32 = 5;
fn main() {
    // 启动一个新线程
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
// 线程间通讯： 通过共享内存
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
// 线程间通讯： 通过通道
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
### sync::Arc
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

### sync::atomic
- 诞生： Rust编程语言在1.34之后的版本中开始正式提供完整的原子(Atomic)类型。
- 原子类型
    - 原子是指一系列不可被上下文交换(Context Switch)的机器指令，这些机器指令组成的操作又称为原子操作(Atomic Operation)。
    - 在多CPU内核的环境下，当某个CPU内核开始运行原子操作时，就会先暂停其它CPU内核对内存的操作，以保证在原子操作运行的过程中，内存内容不会受到其它CPU内核干扰。
    - 原子操作会牵扯到编译器优化以及CPU架构的问题.
- 使用场景： 多线程之间使用原子类型通过共享内存的方式进行线程间通信。
- 使用条件： 支持原子类型操作的指令集架构平台, 如x86/x86_64支持LOCK前缀的指令是原子操作。
- 原子类型优点： 原子操作若用得好，就不需要去使用会拖累程序性能的互斥锁(Mutex)或是消息传递(message passing)机制。

- 为什么需要内存顺序
    - 一些编译器有指令重排功能以优化代码执行效率, 在不同线程中针对同一变量(内存)的读写顺序可能会被打乱, 不能保证顺序的一致性。
    - 一些处理器中有Cache缓存, 对某一内存的读取可能是从缓存中直接读取, 因此不同线程对同一变量的读写顺序亦不能保证一致性。
- Rust原子操作操作有5中内存顺序: Relaxed/Release/Acquire/AcqRel/SeqCst
    1. Relaxed 没有内存顺序约束, 仅仅是原子类型自己的 store/load 函数是原子操作。
    2. Release/Acquire Release之前的写原子操作优先于Acquire之后的读原子操作。
    3. AcqRel 读的时候使用Acquire顺序, 写的时候使用Release顺序。
    4. SeqCst 该原子操作的优先级最低。

1. std::sync::atomic::AtomicBool


## 标准库 其它
```rs
fn main{
    let array = [1, 2, 3];
    dbg!((array.iter().any(|&x| x > 0))); // 只要有一个元素满足条件则立刻返回true
}
```

## 标准库 宏
1. `` dbg!("i am dbg macro") `` 将结果返回并且输出信息到标准错误输出。
2. `` let b = format!("{}", "i am format macro"); `` 将字符串字面量转为字符串。