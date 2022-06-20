
## 标准库
1. std::sync::Arc 原子引用计数（Arc)类型是一种智能指针，它能够让你以线程安全的方式在线程间共享不可变数据。
    ```rust
    use std::thread;
    use std::sync::Arc;
    use std::time::Duration;

    fn main() {
    let name_arc1 = Arc::new(String::from("I Love You")); 
    let name_arc2 = Arc::clone(&name_arc1); 
    // move 关键字批准 name_arc2变量的所有权转移进线程。
    // 由于name_arc2的作用域结束，Arc::drop()就被调用了，name_arc1的原子计数减一
    // 如果name_arc1 和 name_arc2 是常规的变量类型，那么引用变量类型 name_arc2 没法传递进线程里，因为 name_arc1 的生命周期可能小于 name_arc2 的生命周期。
    thread::spawn(move || { 
        thread::sleep(Duration::from_millis(20));
        println!("{:?}", *name_arc2);
    });
    
    println!("{:?}", name_arc1); // Arc::drop()就被调用了，name_arc1的原子计数减一，变成0，name_arc1变量数据被清除
    } 
    ```
2. nce_cell::race::OnceBox 只能被写入一次的线程安全的单元


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

## 宏
1. dbg!() 将结果返回并且输出信息到标准错误输出