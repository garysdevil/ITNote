```rs
use tracing::{trace,debug,info,warn,error};
use tracing_subscriber::{self, util::SubscriberInitExt};

fn main() {
    // 方式一
    // 默认只有error级别的日志才会输出，需要通过设置环境变量改变输出的日志等级 export RUST_LOG=info && cargo run
    // install global collector configured based on RUST_LOG env var.
    // tracing_subscriber::fmt::init(); 
    
    // 方式二
    // 默认只有info以上级别的日志才会输出。
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

    let var_name = 3;
    // this creates a new event, outside of any spans.
    info!(var_name, "Hello from tracing");
}
```

```rs
// use tracing::{trace,debug,info,warn,error};
// use tracing_subscriber::{fmt, layer::SubscriberExt, util::SubscriberInitExt};

// fn main() {
//     // 只有注册 subscriber 后， 才能在控制台上看到日志输出
//     tracing_subscriber::registry()
//         .with(fmt::layer())
//         .init();

//     // 调用 `log` 包的 `info!`
//     info!("Hello world");

//     let var_name = 999;
//     // 调用 `tracing` 包的 `info!`
//     info!(var_name, "Hello from tracing");
// }
```