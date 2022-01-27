## 宏
- 宏按照来源分类
    - 声明宏（Declarative Macro）
        - 用某种语法直接声明出的宏。
        - 可以定义一种符合当前场景的数据结构, 然后使用该宏来编写rust代码.
        - 例如 vec!、println!、write!
    - 过程宏（Procedural Macro）
        - 直接生成抽象语法树过程的宏。
        - 主要是为结构体、元祖等数据结构增加通用的trait公共接口和公共方法.
        - 例如 #[derive(Debug)]、#[derive(PartialEq)] 

- 宏按照使用方式分类
    - 属性宏：给声明添加属性的宏，例如 #[derive(Debug)] 和 #[test]
    - 调用宏：像函数一样的宏，例如 println!

- 区别
    - 声明宏目前只能用 macro_rules! 声明出来，它声明出的一定是调用宏。
    - 过程宏可以产生属性宏，也可以产生调用宏。

### 常用的过程宏
```rust
#![allow(dead_code)] // 此宏必须写在文件顶部，忽略未使用到的代码的警告
#![allow(unused_variables)] // 此宏必须写在文件顶部，忽略未使用大的变量的警告
```

### 定义一个 声明宏
- 定义宏实现创建链表的功能 list
    ```rust
    #[macro_export]
    macro_rules! list {
        // #[macro_export] 标记一个宏可以在其它包中使用，默认为只能被当前包所使用。
        // $x 是变量
        // :expr 是关键字语法, 表示表达式
        // * 表示零次或多次表达式匹配
        ($($x:expr), *) => {
            {
                let mut temp_vec = Vec::new();
                $(                          
                    println!("{}", $x);
                    temp_vec.push($x);
                )*                          // 多次匹配会多次运行这个代码块.
                temp_vec
            }
        }
    }
    
    let x = list!(1,2,3);
    println!("{:?}", x)
    ```
    
## 异步
- std::future::Future
    - future 实例不会轮询（poll）自己
- tokio 
    - 异步运行时（async runtime），提供了运行时和启用异步I/O的功能
    - 文档 https://docs.rs/tokio/latest/tokio/

```rust
// 修改 main 函数使用 tokio 默认执行器（executor）
#[tokio::main]
async fn main() {
    println!("Hello from a (so far completely unnecessary) async runtime");
}
```


```rust
fn main() {
    use std::future;
    async fn run() {
        let a = future::ready(1);
        println!("{}", a.await);
        // assert_eq!(a.await, 1);
    }
}
```

