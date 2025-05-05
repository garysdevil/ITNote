---
created_date: 2022-07-26
---

[TOC]

## 初始化日志系统的几种方式

- tracing_subscriber负责生成span IDs和将它们指派给spans。
- tracing_subscriber对tracing事件`tracing::{trace,debug,info,warn,error};`进行监听，然后进行相关的处理。

### 默认方式启动全局订阅者

```rs
use tracing::{trace,debug,info,warn,error};
use tracing_subscriber;
fn main() {
    // 如果还没有tracing订阅者被配置，则配置一个全局订阅者，通过环境变量RUST_LOG进行日志过滤``export RUST_LOG=info && cargo run``
    tracing_subscriber::fmt::init();  // 默认打印级别 error
    tracing_subscriber::fmt().init(); // 默认打印级别 info
    info!("Hello from tracing");
}
```

### 配置化启动全局订阅者

```rs
use tracing::{trace,debug,info,warn,error};
use tracing_subscriber::{self, util::SubscriberInitExt};

fn main() {
    // Start configuring a `fmt` subscriber
    let subscriber = tracing_subscriber::fmt()
        // Use a more compact, abbreviated log format
        .compact()
        // Display source code file paths
        .with_file(true)
        // Display source code line numbers
        .with_line_number(true)
        // Display the thread ID an event was recorded on
        .with_thread_ids(true)
        // Don't display the event's target (module path)
        .with_target(false)
        // 设置输出的日志等级
        .with_max_level(tracing::Level::INFO)
        // Build the subscriber
        .finish();
    subscriber.init();

    info!("Hello from tracing");
}
```

### 手动设置全局订阅者

```rs
use tracing::{trace,debug,info,warn,error};
use tracing_subscriber;
fn main() {
    // construct a subscriber that prints formatted traces to stdout
    let subscriber = tracing_subscriber::FmtSubscriber::new(); // 默认打印级别 info
    // use that subscriber to process traces emitted after this point
    tracing::subscriber::set_global_default(subscriber).unwrap();
    info!("Hello world");
}
```

### 注册配置全局订阅者

- 抽象出Layer特征，每一个特征可以对同一个事件进行不同的处理。
- tracing_subscriber可以实现多个Layer特征，然后注册多个Layer特征。

```rs
use tracing::{trace,debug,info,warn,error};
use tracing_subscriber::{fmt, layer::SubscriberExt, util::SubscriberInitExt};

fn main() {
    // 只有注册 subscriber 后， 才能在控制台上看到日志输出
    tracing_subscriber::registry()
        .with(fmt::layer())
        .init();

    info!("Hello world");
}
```

### 例子

```rs
fn config_log(debug: bool) {
    let tracing_level = if debug {
        tracing::Level::DEBUG
    } else {
        tracing::Level::INFO
    };

    let subscriber = tracing_subscriber::fmt::Subscriber::builder()
    .with_max_level(tracing_level)
    .finish();

    let log_file: Option<String>;
    log_file = None; //Some(String::from("./log.log"));
    if let Some(file_path) = log_file {
        let file = std::fs::File::create(file_path).unwrap();
        let file = tracing_subscriber::fmt::layer().with_writer(file).with_ansi(false);
        tracing::subscriber::set_global_default(subscriber.with(file))
            .expect("unable to set global default subscriber");
    } else {
        tracing::subscriber::set_global_default(subscriber).expect("unable to set global default subscriber");
    }
}
```
