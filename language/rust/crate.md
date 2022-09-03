[TOC]
## 常用的宝箱
- 文档搜索 https://docs.rs/${宝箱的名字}

```conf
rust-crypto = "0.2.36" # 各种加密算法功能
chrono = { version="0.4.19" } # 时间相关的功能
num_cpus = { version = "1.13.1" } # 获取服务器上的CPU数量
futures-util = { version = "0.3" }  # Combinators and utilities for working with Futures, Streams, Sinks, and the AsyncRead and AsyncWrite traits.
once_cell = { version = "1.12.0"  } # 线程安全的初始化变量，用来存储堆上的信息，并且具有最多只能赋值一次的特征。
criterion = { version = "0.3.5" } # 基准测试工具  文档 https://bheisler.github.io/criterion.rs/book/getting_started.html
backoff = "0.4.0" # 指数级回退和重试机制
bytes = "1.2.1" # 提供高效的字节结构；Buf和BufMut特征。
rusty-hook = "0.11.2" # 可以运行任何脚本的 Git 钩子工具。

# 异常处理
thiserror = "1.0.33" # 为 std::error::Error 特征提供了一个更方便的衍生宏。这个库可以让程序员可以更方便地封装自定义错误。
anyhow = { version="1.0.58" } # 基于 std::error::Error 特征对各种错误类型进行了封装。

# 随机数
rand = { version = "0.8.5" } # 随机数生成器
rand_chacha = { version = "0.3.1" } # 使用ChaCha算法的加密安全随机数生成器

# gpu
rust-gpu = { version = "0.1.0" }

# 序列化
bincode = "1.2.1" # 序列化与反序列化功能
serde = { version = "1.0.137", features = ["derive"] } # 通过派生宏给结构体、枚举、联合体提供序列化特征

# 数据库
rocksdb = { version = "0.19.0" } # rocksdb的rust封装，即通过rust调用rocksdb c++ api

# 异步编程
futures = { version = "0.3.21" } # 对异步编程的抽象
tokio = { version = "1.19.2", features = ["full"] } # 异步运行时库
tokio-util = { version = "0.7.3" } # tokio的附加工具
tokio-stream = { version = "0.1.9" } # 迭代器，异步版本的std::iter::Iterator特征
jsonrpsee = { version = "0.14.0" } # 建立在tokio异步运行时库上的web服务框架
futures-util = "0.3.21" # Common utilities and extension traits for the futures-rs library.

# web
warp = "0.3.2" # web服务器框架

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

## rayon
- 对比标准库中的迭代函数
    - rayon并行迭代函数内的闭包不能改变外部状态。
    - rayon并行迭代函数会有些不同。

- 功能
    - Rayon并行迭代器负责确定如何将数据划分为并行任务。动态适应以达到最佳性能。
    - Rayon提供了join和scope函数，允许用户自己创建并行任务。提供了更大的灵活性。
    - 可以创建自定义线程池，而不是使用Rayon的默认全局线程池。获得了更多控制。

- 工作原理
    - 通过线程间 Work stealing 的方式达到并行。 

```rs
fn main() {
    // 手动配置 rayon 线程池
    rayon::ThreadPoolBuilder::new()
        .stack_size(8 * 1024 * 1024)
        .num_threads((num_cpus::get() / 2).max(1)) // 设置并行线程数为系统逻辑线程数的一半 // 也可以通过环境变量进行设置RAYON_NUM_THREADS
        .build_global()
        .unwrap();
    dbg!(rayon::current_num_threads()); // 输出线程池最大并行线程数
}

use rayon::prelude::*;
fn sum_of_squares(input: &[i32]) -> i32 {
    // input.iter() // 使用串行模式 
    input.par_iter() // 使用rayon将串行模式改为并行模式
         .map(|&i| i * i)
         .sum()
}
```

## rocksdb
- 默认会创建rocksdb:low 和 rocksdb:high两个线程。

```rs
use rocksdb::{DB, Options};

pub fn main() {
    // NB: db is automatically closed at end of lifetime
    let path = "/Users/gary/git/NOTE/myrust/local_path_for_rocksdb_storage";
    {
        let db = DB::open_default(path).unwrap(); // 连接rocksdb数据库，如果不存在则自动创建
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


## rand
```rs
use rand::prelude::*;

fn main() {
    // 方式一 生成随机数
    let x: u8 = random();
    println!("{}", x);

    // 方式二 生成布尔值
    if random() {
        println!("Heads!");
    }

    // 方式三 通过更高效一点的方式，生成更精确范围的随机数
    let mut rng = thread_rng();
    if rng.gen() { // 生成布尔值
        let x: f64 = rng.gen(); // 生成 [0, 1)
        let y = rng.gen_range(0..=u64::MAX);
        println!("x is: {}", x);
        println!("y is: {}", y);
    }
    
    // 方式四 Sometimes it's useful to use distributions directly:
    let distr = rand::distributions::Uniform::new_inclusive(1, 100);
    let mut nums = [0i32; 3];
    for x in &mut nums {
        *x = rng.sample(distr);
    }
    println!("Some numbers: {:?}", nums);

    // 方式五 We can also interact with iterators and slices:
    let arrows_iter = "➡⬈⬆⬉⬅⬋⬇⬊".chars();
    println!("Lets go in this direction: {}", arrows_iter.choose(&mut rng).unwrap());
    let mut nums = [1, 2, 3, 4, 5];
    nums.shuffle(&mut rng);
    println!("I shuffled my {:?}", nums);
}

```


## backoff
- 可以用于同步和异步编程中


```toml
[dependencies]
backoff = "0.4.0"
reqwest = {version = "0.11", features = ["json", "blocking"]}
```
```rs
fn main() {
    use backoff::{retry, Error, ExponentialBackoff};

    let op = || {
        println!("---");
        let result = reqwest::blocking::get("https://baidu.com").map_err(Error::transient);
        // match result{
        //     Err(e) => println!("{}", e),
        //     Ok(o)  => println!("{:?}", o),
        // };
        println!("{:?}", &result);
        result
    };
    let backoff = ExponentialBackoff::default();
    // backoff.current_interval = std::time::Duration::from_secs(1);
    retry(backoff, op).err().unwrap();
}
```

## bytes
- Bytes
- BytesMut 容量会进行伸缩。

```rs
fn main1() {
    use bytes::Bytes;

    let mut mem = Bytes::from("Hello world");
    let mem_1 = mem.slice(0..5); // 复制数据
    let mem_2 = mem.split_to(6); // 切割 mem 的数据

    assert_eq!(mem_1, "Hello"); 
    assert_eq!(mem, "world");
    assert_eq!(mem_2, "Hello ");
}
fn main2() {
    use bytes::{BytesMut, BufMut};

    let mut buf = BytesMut::with_capacity(1024);

    buf.put(&b"hello world"[..]);
    buf.put_u16(1234);
    let buf_1 = buf.split(); // 移动 buf 的数据被给 buf_1
    assert_eq!(buf_1, b"hello world\x04\xD2"[..]);

    assert!(buf.is_empty());
    assert_eq!(buf.capacity(), 1011);
}
```

## wrap
```rs
use warp::Filter;

#[tokio::main]
async fn main() {
    // GET /hello/warp => 200 OK with body "Hello, warp!"
    let hello = warp::path!("hello" / String)
        .map(|name| format!("Hello, {}!", name));

    warp::serve(hello)
        .run(([127, 0, 0, 1], 8888))
        .await;
}
```

## ansi_term
```rs
use ansi_term::Colour::Red;
use ansi_term::Colour::Cyan;
fn main() {
    println!("This is in red: {}", Red.paint("a red string"));
    println!(
        "{}", 
        Cyan.normal().paint(format!(
        "Total proofs: {} (1m: {} p/s, 5m: {} p/s, 15m: {} p/s, 30m: {} p/s, 60m: {} p/s)",
        100, 1, 2, 3, 4, 5
        ))
    )
}
```

## colored
```rs
use colored::*;
fn main() {
    println!("{}", "this is blue".blue());
    println!("{}", "this is red".red());
    println!("{}", "this is red on blue".red().on_blue());
    println!("{}", "this is also red on blue".on_blue().red());
    println!("{}", "you can use truecolor values too!".truecolor(0, 255, 136));
    println!("{}", "background truecolor also works :)".on_truecolor(135, 28, 167));
    println!("{}", "bright colors are welcome as well".on_bright_blue().bright_red());
    println!("{}", "you can also make bold comments".bold());
    println!("{}", "or change advice. This is red".yellow().blue().red());
    println!("{}", "or clear things up. This is default color and style".red().bold().clear());
    println!("{}", "purple and magenta are the same".purple().magenta());
    println!("{}", "and so are normal and clear".normal().clear());
    println!("{}", "you can specify color by string".color("blue").on_color("red"));
    println!("{}", String::from("this also works!").green().bold());
    println!("{}", format!("{:30}", "format works as expected. This will be padded".blue()));
    println!("{}", format!("{:.3}", "and this will be green but truncated to 3 chars".green()));
    println!("{} {} {}", "or use".cyan(), "any".italic().yellow(), "string type".cyan());

    println!(
        "{}", 
        format!(
        "Total proofs: {} (1m: {} p/s, 5m: {} p/s, 15m: {} p/s, 30m: {} p/s, 60m: {} p/s)",
        100, 1, 2, 3, 4, 5
        ).blue()
    )
}
```