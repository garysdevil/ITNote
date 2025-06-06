---
created_date: 2022-09-16
---

[TOC]

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

        // 查看有多少个sst文件
        let livefiles = db.live_files().unwrap();
        println!("{}",livefiles.len());
        
        // 迭代
        let iter = db.iterator(IteratorMode::Start); // 返回kv迭代
        assert!(iter.next().is_none()); // 往后进行一次迭代
        // 遍历数据库
        for (idx, (db_key, db_value)) in iter.map(Result::unwrap).enumerate() {
            // println!("{}", idx);
            println!("{}, {}, {}", idx, String::from_utf8(db_key.to_vec()).expect("Found invalid UTF-8"), String::from_utf8(db_value.to_vec()).expect("Found invalid UTF-8"));
        }
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
