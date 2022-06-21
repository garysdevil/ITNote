
## 标准库
1. std::sync::Arc 原子引用计数（Arc)类型是一种智能指针，它能够让你以线程安全的方式在线程间共享不可变数据。
    ```rust
    use std::thread;
    use std::time::Duration;
    use std::sync::Arc;

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

2. nce_cell::race::OnceBox 只能被写入一次的线程安全的单元

3. std::time 时间
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