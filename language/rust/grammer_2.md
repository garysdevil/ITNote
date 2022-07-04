[TOC]

## 一 智能指针
- 指针（pointer）是一个包含内存地址的变量的通用概念。Rust中的引用就是一种指针，它只能指向一个数据，没有特别的功能。
- 智能指针（smart pointer）是一种数据结构，它不仅可以指向一个数据并且可以拥有这个数据的所有权，还拥有元数据和功能。

- String 和 Vec<T> 就属于智能指针。

- 智能指针通常使用结构体来实现。智能指针区别于常规结构体的显著特性在于其实现了 Deref 和 Drop 特性。
    - Deref 特性允许一个数据类型被当作引用对待。
    - Drop 特性可以让当变量离开作用域时，它所指向的堆数据也会被清除。

### Box<T> 最简单的智能指针
- 最简单直接的智能指针是 box，其类型是 Box<T>。 Box<T> 允许你将一个值分配到堆上，然后在栈上保留一个智能指针指向堆上的数据。

- 可以在以下场景中使用它
    1. 特意的将数据分配在堆上
    2. 数据较大时，又不想在转移所有权时进行数据拷贝
    3. 类型的大小在编译期无法确定，但是我们又需要固定大小的类型时
    4. 特征对象，用于说明对象实现了一个特征，而不是某个特定的类型

```rs
fn main() {
    let var_box1 = Box::new(5); // 数值5被放入了堆上
    println!("b = {}", var_box1); // 隐式地调用了 Deref 对智能指针 var_box 进行了解引用
    let var_box2 = *var_box1 + 1;  // 在表达式中，无法自动隐式地执行 Deref 解引用操作，需要使用 * 操作符来显式的对 var_box1 进行解引用

    let var_box_arr = Box::new([0;1000]); // 当数据很大时，使用Box类型将数据被放入堆中。当变量被拷贝时，就只会触发所有权的转移，避免过多的性能开销。
}
```

```rs
// 使用Box将动态大小类型变为 Sized 固定大小类型
// 创建一个递归类型
// Rust 需要在编译时知道类型占用多少空间。一种无法在编译时知道大小的类型是 递归类型（recursive type），其值的一部分可以是相同类型的另一个值。这种值的嵌套理论上可以无限的进行下去，所以 Rust 不知道递归类型需要多少空间。不过 box 有一个已知的大小，所以通过在循环类型定义中插入 box，就可以创建递归类型了。

// enum List { // 错误
//     Cons(i32, List),
//     Nil,
// }
// use List::{Cons, Nil};
// fn main() {
//     let list = Cons(1, Cons(2, Cons(3, Nil)));
// }
enum List {
    Cons(i32, Box<List>),
    Nil,
}
use List::{Cons, Nil};
fn main() {
    let list = Cons(1, Box::new(Cons(2, Box::new(Cons(3, Box::new(Nil))))));
}
```

### Deref 特性
- Deref 实现的3种转换
    1. 当 T: Deref<Target=U>，可以将 &T 转换成 &U
    2. 当 T: DerefMut<Target=U>，可以将 &mut T 转换成 &mut U
    3. 当 T: Deref<Target=U>，可以将 &mut T 转换成 &U

```rs
// 自定义一个智能指针
struct MyBox<T>(T);
impl<T> MyBox<T> {
    fn new(x: T) -> MyBox<T> {
        MyBox(x)
    }
}
use std::ops::Deref;
impl<T> Deref for MyBox<T> { // 实现 Deref 特性，当进行解引用时，会自动对智能指针里面的数据进行解引用
    type Target = T;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}
use std::ops::DerefMut;
impl<T> DerefMut for MyBox<T> { // 实现 Deref 特性，当进行解引用时，会自动对智能指针里面的可变数据进行解引用
    fn deref_mut(&mut self) -> &mut Self::Target {
        &mut self.0
    }
}
fn display(s: &mut String) {
    s.push_str("world");
    println!("{}", s);
}
fn main() {
    // 解引用示范
    let var_box_1 = 5;
    let var_box_2 = MyBox::new(var_box_1);
    assert_eq!(5, var_box_1);
    assert_eq!(5, *var_box_2); // 通过 * 操作符对y进行显示地解引用， *y 等价于 *(y.deref()) 

    // 解引用示范
    let var_box_3 = MyBox::new(String::from("Rust")); 
    println!("{:?}", &(*var_box_3)[..]); // 通过 (*m) 解引用出 String 类型的数据，再通过 &()[..] 获取字符串切片
    println!("{:?}", *var_box_3); // Rust机制中的 deref 特性自动帮我们进行了解引用

    // 解引用示范 // 可变解引用
    let mut var_box_4 = String::from("hello");
    display(&mut var_box_4);
}
```

### Drop 特性
- 互斥的 Copy 和 Drop ，我们无法为一个类型同时实现 Copy 和 Drop 特征。因为实现了 Copy 的特征会被编译器隐式的复制。
```rs
struct CustomSmartPointer {
    data: String,
}

impl Drop for CustomSmartPointer {
    fn drop(&mut self) {
        println!("Dropping CustomSmartPointer with data `{}`!", self.data);
    }
}
fn main() {
    let c = CustomSmartPointer {
        data: String::from("my stuff"),
    };
    let d = CustomSmartPointer {
        data: String::from("other stuff"),
    };
    println!("CustomSmartPointers created.");
    // c.drop() // 编译器不允许我们直接调用c.drop()函数来清理变量的内存，因为当变量的作用域未结束时，后面的代码依然可以使用这个变量，那么这个变量的指向就是空的，非常不安全。编译器在变量作用域结束后会自动进行调用。
    drop(c); // 但我们可以通过 std::mem::drop(c) 来提前清理数据，这个函数会拿走变量的所有权，作用域内后面的代码将无法使用这个变量，因此此方式是内存安全的。
    println!("Leaving scope");
}
```

### Rc<T> 引用计数智能指针
- Rc<T> 通过引用计数的方式，允许一个数据资源在同一时刻拥有多个所有者。
- Rc<T> 只能被使用于单线程场景上。
- Rc<T> 是指向底层数据的不可变的引用，因此你无法通过它来修改数据，这也符合 Rust 的借用规则：要么存在多个不可变借用，要么只能存在一个可变借用。

```rs
use std::rc::Rc;
fn main() {
    let var_rc_1 = Rc::new(String::from("hello, world"));
    let var_rc_2 = Rc::clone(&var_rc_1); // 区别于var_rc_1.clone()函数对数据的深层拷贝，Rc::clone(&var_rc_1)函数只是增加了引用计数。

    assert_eq!(2, Rc::strong_count(&var_rc_1)); // 变量var_rc_1的引用计数为2
    assert_eq!(Rc::strong_count(&var_rc_1), Rc::strong_count(&var_rc_2))  // 变量 var_rc_1 和 var_rc_2 拥有同样的引用计数，因为它们是同一个智能指针的两个副本。
}
```

### RefCell<T> 内部可变引用计数 （Todo 未悟透，还需要学习）
- RefCell<T>  通过将安全检查放置运行时，提供了一个可以用于当需要不可变类型但是需要改变其内部值能力的类型。但依然需要在运行时遵守所有权借用规则，否则会导致panic。

```rs

fn main() {
    // let x = 5;
    // let y = &mut x;

    use std::cell::RefCell;
    let var_refcell_1 = RefCell::new(5);
    let var_refcell_2 = var_refcell_1.borrow_mut(); // 
    // let var_refcell_2 = var_refcell_1.borrow(); // 可以编译通过，但在运行时打破借用规则，触发panic
}
```

### 引用循环与内存泄漏 （Todo 未悟透，还需要学习）


## 并发编程
- 序
    - 随着时间的推移，团队发现所有权和类型系统是一系列解决内存安全 和 并发问题的强有力的工具！
    - 通过利用所有权和类型检查，在 Rust 中很多并发错误都是 编译时 错误，而非运行时错误。

- 主线程的结束，spawn 线程也随之结束。
- join 方法可以使子线程运行结束后再停止运行程序。

- 通道（channel）是实现线程间消息传递的主要工具，通道有两部分组成，一个发送者（transmitter）和一个接收者（receiver）。

### 线程
```rust
use std::thread;
use std::time::Duration;

fn func_spawn() {
    for i in 0..5 {
        println!("func_spawn: spawned thread print {}", i);
        thread::sleep(Duration::from_millis(1));
    }
}

fn main() {
    // 必包函数/匿名函数
    let inc = |num: i32| -> i32 {
        num + 1
    };
    println!("inc(5) = {}", inc(5));

    // 运行一个线程 
    thread::spawn(func_spawn);

    thread::spawn(|| { // 必包函数/匿名函数
        for i in 0..5 {
            println!("closures: spawned thread print {}", i);
            thread::sleep(Duration::from_millis(1));
        }
    }).join().unwrap(); // join方法使主线程等待当前线程执行结束

    for i in 0..3 {
        println!("main thread print {}", i);
        thread::sleep(Duration::from_millis(1));
    }

    let var_string = "hello";
    let handle = thread::spawn(move || {
        println!("{}", var_string);
    });
    handle.join().unwrap();
}
```

## 面向对象编程
- test.rs
```rust
pub struct ClassName {
    id: i32,
}

impl ClassName {
    pub fn new(value: i32) -> ClassName {
        ClassName {
            id: value
        }
    }

    pub fn public_method(&self) {
        println!("from public method");
        self.private_method();
    }

    fn private_method(&self) {
        println!("from private method");
    }
}
```
- main.rs
```rust
mod test;
use test::ClassName;

fn main() {
    let object = ClassName::new(1024);
    object.public_method();
}
```


### 通道
```rust
use std::thread;
use std::sync::mpsc;

fn main() {
    // 获取通道消息的 发送者和接收者
    let (transmitter, receiver) = mpsc::channel();

    // 启动一个线程
    thread::spawn(move || {
        let var_name = String::from("hi");
        // 向通道发送消息
        transmitter.send(var_name).unwrap();
    
    });

    // 向通道接收消息
    let received = receiver.recv().unwrap();
    println!("Got: {}", received);
}
```

## Rust的异同
- rust编程语言里 不支持 ++ 和 -- 的数学运算符号。

- rust编程语言里 没有 for 的三元语句控制循环，例如 for (i = 0; i < 10; i++)

- () 是一种特殊的类型，值只有一个就是() 
    - https://doc.rust-lang.org/std/primitive.unit.html