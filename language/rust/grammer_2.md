## 宏
- 宏按照来源分类
    - 声明宏（Declarative Macro）：用某种语法直接声明出的宏。
    - 过程宏（Procedural Macro）：直接生成抽象语法树的过程的宏。
- 宏按照使用方式分类
    - 属性宏：给声明添加属性的宏，例如 #[derive(Debug)] 和 #[test]
    - 调用宏：像函数一样的宏，例如 println!


- 声明宏目前只能用 macro_rules! 声明出来，它声明出的一定是调用宏。
- 过程宏可以产生属性宏，也可以产生调用宏。

### 定义一个 声明宏
- 定义宏 println!
    ```rust
    #[macro_export]
    macro_rules! println {
        () => (println!("\n"));
        ($fmt: expr) => (print!(concat!($fmt, "\n")));
        ($fmt: expr, $($(arg:tt)*) =>
            (print!(concat!($fmt, "\n"), $($arg)*));
    }
    ```
    - #[macro_export] 标记一个宏可以在其它包中使用，默认为只能被当前包所使用。
    - 宏由三部分组成，分别是 ()、 ($fmt:expr)、 ($fmt: expr, $($args:tt)*)
    - $fmt 是对宏参数的捕获，类似于函数的参数； expr 表示这个捕获的类型是表达式。
    