[TOC]
## 宏
- 宏按照来源分类
    - 声明宏（Declarative Macro）
        - 用某种语法直接定义出的宏。
        - 可以定义一种符合当前场景的数据结构, 然后使用该宏来编写rust代码。
        - 例如 vec!、println!、write!
    - 过程宏（Procedural Macro）
        - 直接生成抽象语法树过程的宏。
        - 主要是为结构体、元祖等数据结构增加通用的trait公共接口和公共方法.
        - 例如 #[derive(Debug)]、#[derive(PartialEq)] 
        - 自定义过程宏，必须引入官方的过程宏库 proc_macro，或者引入第三方更友好的库syn、quote、proc_macro2
    - 区别
        - 声明宏只能用 macro_rules! 来定义出来，它定义出的一定是调用宏。
        - 过程宏可以产生属性宏，也可以产生调用宏。

- 过程宏分为三种
    1. 派生宏（Derive macro）：用于结构体（struct）、枚举（enum）、联合（union）类型，可为其实现函数或特征（Trait）。
    2. 属性宏（Attribute macro）：用在结构体、字段、函数等地方，为其指定属性等功能。如标准库中的#[inline]等都是属性宏。
    3. 函数式宏（Function-like macro）：用法与普通的规则宏类似，但功能更加强大，可实现任意语法树层面的转换功能。
    - 函数式宏和属性宏拥有修改原AST的能力，而派生宏只能做追加的工作.

- 宏按照使用方式分类
    - 属性宏：给类型添加属性的宏，例如 #[derive(Debug)] 和 #[test]
    - 调用宏：像函数一样的宏，例如 println!

- 宏和函数的对比
    - 函数必须明确参数的数量和类型。
    - 宏可以有各种各样的参数。

- 对比C/C++
    - C/C++中的宏，在预编译阶段通过文本替换。
    - 在词法层面甚至语法树层面作替换，其功能更加强大，也更加安全。

### 标准库中的宏
```rust
#![allow(dead_code)] // 此宏必须写在文件顶部。此宏表示忽略未使用到到的代码的警告。
#![allow(unused_variables)] // 此宏必须写在文件顶部。此宏表示忽略未使用到的变量的警告。
```

### 定义和使用 声明宏
- 定义宏实现创建链表的功能 list
    ```rust
    #[macro_export] // #[macro_export] 标记一个宏可以在其它包中使用，默认为只能被当前包所使用。
    macro_rules! list { // macro_rules! 表示定义创建一个声明宏，名字为 list
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
    
    let x = list!(1,2,3); // 通过 声明宏名字!(参数...) 来使用声明宏
    println!("{:?}", x)
    ```

### 定义和使用 派生宏
```rust
#[proc_macro_derive(Builder)] // #[proc_macro_derive(Builder) ]表示 derive_builder 是一个派生宏
fn derive_builder(input: TokenStream) -> TokenStream {
    let _ = input;

    unimplemented!()
}

#[derive(Builder)] // 通过在结构体枚举联合类型上标注 #[derive(过程宏名字)] 来使用过程宏
struct Command {
    // ...
}
```

### 定义和使用 属性宏
```rs
#[proc_macro_attribute] // #[proc_macro_attribute] 表示定义一个属性宏
// 定义属性宏时，函数传入两个参数，第一个表示属性宏传入的参数，第二个参数表示所关联的类型主体。
// 例如下面所属，GET 和 "/" 表示传入的第一个参数，fn index() {} 表示传入的第二个参数。
pub fn route(attr: TokenStream, item: TokenStream) -> TokenStream { 
    // ..
}

#[route(GET, "/")] // 通过在一个类型上标注 #[属性宏(参数, 参数)] 来使用一个属性宏
fn index() {}
```

### 定义和使用 函数宏
```rs
#[proc_macro] // proc_macro 表示定义一个函数宏
pub fn sql(input: TokenStream) -> TokenStream {
    // ...
}


let sql = sql!(SELECT * FROM posts WHERE id=1); // 通过 sql!() 函数宏的名字和感叹号来使用使用函数宏
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


## 条件编译
- Rust代码里有一个特殊的属性, #[cfg], 它可以传递标识给编译器，然后选择性编译代码。

### 条件编译一
```rust
#[cfg(target_os = "linux")]
fn fun_condition_1() {
    println!("1. You are running in linux!")
}

#[cfg(not(target_os = "linux"))]
fn fun_condition_1() {
    println!("1. You are not running in linux!")
}

#[cfg(feature = "some_condition")]
fn fun_condition_2() {
    println!("condition met!")
}
#[cfg()]
fn fun_condition_2() {
    println!("condition met!")
}

fn main() {
    fun_condition_1()
    fun_condition_2() // rustc --cfg some_condition  main.rs // 如果这个函数不满足条件但又被调用则编译时会报错

    if cfg!(target_os = "windows") {
        println!("2. You are running in windows!")
    } else if cfg!(target_os = "linux") {
        println!("2. You are running in linux!")
    } else {
        println!("2. You are runing in other system!")
    }
}
```

### 条件编译二 可以在Cargo.toml里进行配置编译条件
```conf
[features]
default = ["feature1"] # 默认使用feature1条件
feature1 = []
feature2 = []
```
```rust
#[cfg(feature="feature1")]
pub fn test1() {
    // ...
}
```

## 范性深入
```rust
struct S;
impl S{
    fn f(){ println!("S f()"); }
}
trait T1{
    fn f() { println!("T1 f()"); }
}
trait T2{
    fn f() { println!("T2 f()"); }
}
impl T1 for S{}
impl T2 for S{}

// 1. 当结构体实现了两个特征，并且这两个特别拥有相同名字的函数时，可以通过如下方式进行区分。
fn test(){
    S::f(); // 默认先调用结构体方法
    // 完全限定无歧义调用
    <S as T1>::f();
    <S as T2>::f();
}
```

```rust
use std::any::type_name;
fn type_name_of<T>(_: T) {
    println!("{:?}", { type_name::<T>() });
}
fn test(){
    // 2. 泛型函数-turbofish操作符
    let vec1 = (0..10).collect::<Vec<u8>>(); // 将迭代转化为8bit无符号整型数据类型的Vec集合
    let vec2 = (0..10).collect::<Vec<_>>(); // 使用一个通配符，自动推断数据类型，将迭代转化为Vec集合
    println!("{:?}", type_name_of(vec1));
    println!("{:?}", type_name_of(vec2));
    Vec::<u8>::with_capacity(1024); // 生成拥有1024容量的8bit无符号整型数据类型的Vec集合
}
```


## 栈堆
- 栈
    - 栈内存从高位地址向下增长，且栈内存是连续分配的，一般来说操作系统对栈内存的大小都有限制，因此 C 语言中无法创建任意长度的数组。
    - 在 Rust 中，main 线程的栈大小是 8MB，普通线程是 2MB，在函数调用时会在其中创建一个临时栈空间，调用结束后 Rust 会让这个栈空间里的对象自动进入 Drop 流程，最后栈顶指针自动移动到上一个调用栈顶，无需程序员手动干预，因而栈内存申请和释放是非常高效的。
- 堆
    - 堆上内存则是从低位地址向上增长，堆内存通常只受物理内存限制，而且通常是不连续的，因此从性能的角度看，栈往往比堆更高。

- 语言对比
    - 相比其它语言，Rust 堆上对象还有一个特殊之处，它们都拥有一个所有者，因此受所有权规则的限制：当赋值时，发生的是所有权的转移。

- 堆栈性能
    1. 小型数据，在栈上的分配性能和读取性能都要比堆上高
    2. 中型数据，栈上分配性能高，但是读取性能和堆上并无区别，因为无法利用寄存器或 CPU 高速缓存，最终还是要经过一次内存寻址
    3. 大型数据，只建议在堆上分配和使用
    - 栈的分配速度肯定比堆上快，但是读取速度往往取决于你的数据能不能放入寄存器或 CPU 高速缓存。

## turbofish 涡轮鱼
- 参考 
    - https://stackoverflow.com/questions/52360464/what-is-the-syntax-instance-methodsomething
    - https://matematikaadit.github.io/posts/rust-turbofish.html

- turbofish，通常用于在表达式中为泛型类型、函数或方法指定具体的参数类型。

```rs
fn main () {
    // let var_a = (0..255).sum(); // 编译器无法推断出数据类型，报错
    let var_b = (0..255).sum::<u32>(); // 通过turbofish语法，指定参数类型
    let var_c: u32 = (0..255).sum(); // 直接定义了变量var_c的数据类型
}
```

```rs
```rs
use core::fmt::Debug;

fn foo<T: Default + Debug>() { // 可以通过这种方式传入一个泛型，此泛型必须实现了Default和Debug特征
    let t: T = Default::default();
    // or
    // let t = <T as Default>::default();
    println!("{t:?}");
}

fn main() {
    foo::<u32>(); // 通过turbofish语法，指定参数类型
}
```
```