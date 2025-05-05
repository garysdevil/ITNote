---
created_date: 2022-07-05
---

[TOC]

## 一 智能指针
- 指针（pointer）是一个包含内存地址的变量的通用概念。Rust中的引用就是一种指针，它只能指向一个数据，没有特别的功能。
- 智能指针（smart pointer）是一种数据结构，它不仅可以指向一个数据并且可以拥有这个数据的所有权，还拥有元数据和功能。

- String 和 Vec<T> 就属于智能指针。

- 智能指针通常使用结构体来实现。智能指针区别于常规结构体的显著特征在于其实现了 Deref 和 Drop 特征。
    - Deref 特征允许一个数据类型被当作引用对待。
    - Drop 特征可以让当变量离开作用域时，它所指向的堆数据也会被清除。

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

### Deref 特征
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
impl<T> Deref for MyBox<T> { // 实现 Deref 特征，当进行解引用时，会自动对智能指针里面的数据进行解引用
    type Target = T;

    fn deref(&self) -> &Self::Target {
        &self.0
    }
}
use std::ops::DerefMut;
impl<T> DerefMut for MyBox<T> { // 实现 Deref 特征，当进行解引用时，会自动对智能指针里面的可变数据进行解引用
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
    println!("{:?}", *var_box_3); // Rust机制中的 deref 特征自动帮我们进行了解引用

    // 解引用示范 // 可变解引用
    let mut var_box_4 = String::from("hello");
    display(&mut var_box_4);
}
```

### Drop 特征
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
- RefCell<T> 通过将安全检查放置运行时，提供了一个可以用于当需要不可变类型但是需要改变其内部值能力的类型。但依然需要在运行时遵守所有权借用规则，否则会导致panic。
- RefCell<T> 只能被使用于单线程场景上。

```rs
use std::cell::RefCell;
fn main() {
    // let x = 5;
    // let y = &mut x;
    let var_refcell_1 = RefCell::new(5);
    let var_refcell_2 = var_refcell_1.borrow_mut(); // 
    let var_refcell_3 = var_refcell_1.borrow(); // 可以编译通过，但如果在运行时打破借用规则，依然会触发panic
}
```

### 引用循环与内存泄漏 （Todo 未悟透，还需要学习）


## 二 并发编程
- 序
    - 随着时间的推移，团队发现所有权和类型系统是一系列解决内存安全 和 并发问题的强有力的工具！
    - 通过利用所有权和类型检查，在 Rust 中很多并发错误都是 编译时 错误，而非运行时错误。

- 线程
    - 主线程的结束，子线程也随之结束。
    - spawn 关联函数可以产生一个新的子线程。
    - join 关联函数可以阻塞主线程，知道子线程运行结束。

- 通讯
    - 线程间的通讯和Go一样遵循着同样的原则 “Do not communicate by sharing memory; instead, share memory by communicating.”
    - 通道（channel）是实现线程间消息传递的主要工具。
        - 通道有两部分组成，一个发送者（transmitter）和一个接收者（receiver）。
        - 可以有多个发送者（transmitter）。
    - 共享状态
        - 互斥锁 Mutex<T>  互斥锁并没有实现Send特征，因此不能被发送到另一个线程。
        - 多线程安全的引用计数智能指针 Arc<T>
### 线程
```rust
// 线程
use std::thread;
use std::time::Duration;

fn func_spawn() {
    println!("func_spawn: spawned thread print nothing");
}

fn main() {
    // 运行一个线程 
    thread::spawn(func_spawn);

    thread::spawn(|| { // 通过必包函数运行一个线程
        for i in 0..5 {
            println!("closures: spawned thread_1 print {}", i);
            thread::sleep(Duration::from_millis(1));
        }
    });

    // 通过必包函数运行一个线程
    thread::spawn(|| {
        for i in 0..5 {
            println!("closures: spawned thread_2 print {}", i);
            thread::sleep(Duration::from_millis(1));
        }
    }).join().unwrap(); // join方法会阻塞主线程，但不影响没有join()的子线程的运行


    let var_string = String::from("hello");
    // 通过必包函数运行一个线程，并且返回线程的句柄
    let handle = thread::spawn(move || { // 通过 move 关键字，将被捕获到的变量所有权转移进闭包函数内
        println!("{}", var_string);
    });
    let thread = handle.thread(); // 获取潜在线程的句柄
    println!("thread id: {:?}", thread.id()); // 获取线程的唯一标识符
    println!("thread name: {:?}", thread.name()); // 获取线程的名字
    handle.join().unwrap(); // // join方法会阻塞主线程，但不影响没有join()的子线程的运行

    println!("main thread ending");
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


### 共享内存
- 共享内存可以说是同步的灵魂，因为消息传递的底层实际上也是通过共享内存来实现，两者的区别如下
    1. 共享内存相对消息传递能节省多次内存拷贝的成本。
    2. 共享内存的实现简洁的多。
    3. 共享内存的锁竞争更多。

- 所有权
    - 消息传递类似一个单所有权的系统：一个值同时只能有一个所有者，如果另一个线程需要该值的所有权，需要将所有权通过消息传递进行转移。
    - 共享内存类似于一个多所有权的系统：多个线程可以同时访问同一个值。

- 锁
    1. Mutex 每次进行读写都需要获取锁。
    2. RwLock 同时允许多个读，但最多只能有一个写。
    3. RwLock 是操作系统提供的，实现原理要比Mutex复杂的多，因此单就锁的性能而言，比不上原生实现的Mute。
- 使用锁时的注意事项
    1. 在使用数据前必须先获取锁。
    2. 在数据使用完成后，必须及时的释放锁。

```rs
// 单线程与锁
fn main() {
    let m = Mutex::new(5); // Mutex 

    let mut num = m.lock().unwrap();
    *num = 6;
    // 锁还没有被 drop 就尝试申请下一个锁，导致主线程阻塞
    // drop(num); // 手动 drop num ，可以让 num1 申请到下个锁
    let mut num1 = m.lock().unwrap();
    *num1 = 7;
    // drop(num1); // 手动 drop num1 ，观察打印结果的不同

    println!("m = {:?}", m);
}
```

```rs
// 多线程与锁 
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let counter = Arc::new(Mutex::new(0)); // 当变量被多个线程使用时，让数据资源拥有多个所有者。使用多线程安全的引用计数智能指针Arc将其包裹起来用于共享状态
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter); // 分别拷贝一份进子线程里
        let handle = thread::spawn(move || { // 多个线程共享 counter 状态
            let mut num = counter.lock().unwrap(); // Mutex<T> 也提供了 内部可变性 的功能，因此即使 counter 变量是不可变的，但 T 的值是可以变的。

            *num += 1; 
            // 当变量 num 作用域结束时，自动解锁。
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    println!("Result: {}", *counter.lock().unwrap());
}
```


## 三 面向对象编程
- 面向对象编程的特点是
    - 数据和行为 Rust通过结构体和枚举来包含数据，通过``impl``块来实现行为。
    - 封装 Rust通过``pub``关键字来实现了封装。
    - 继承 Rust机制中没有继承，但对于代码复用，可以通过`` trait``来实现。
    - 多态 Rust机制中没有多态这个概率，但对于一段代码处理多种类型的数据，可以通过泛型实现。

```rs
/// 定义一个“对象”
pub struct AveragedCollection {
    list: Vec<i32>,
    average: f64,
}
// 定义“对象”内的方法
impl AveragedCollection {
    pub fn add(&mut self, value: i32) {
        self.list.push(value);
        self.update_average();
    }

    pub fn remove(&mut self) -> Option<i32> {
        let result = self.list.pop();
        match result {
            Some(value) => {
                self.update_average();
                Some(value)
            }
            None => None,
        }
    }

    pub fn average(&self) -> f64 {
        self.average
    }

    fn update_average(&mut self) {
        let total: i32 = self.list.iter().sum();
        self.average = total as f64 / self.list.len() as f64;
    }

    // pub fn new(list: Vec<i32>) -> AveragedCollection {}
    
    pub fn new() -> AveragedCollection {
        let list = Vec::new();
        let average = 0.0;
        AveragedCollection {
            list,
            average
        }
    }
}
fn main() {
    // 实例化一个”对象“
    let mut object = AveragedCollection::new();
    object.add(3);
}
```

## 四 模式匹配
- 模式匹配分为 refutable 模式 和 irrefutable 模式
    - refutable 意味着模式匹配存在匹配失败的可能性。像 match，while let 都需要refutable类型的模式匹配。
    - irrefutable 意味着模式一定要匹配成功。像 let声明，输入参数 都需要irrefutable类型的模式匹配。

```rs
// match 模式匹配
fn main() {
    let x = 1;

    match x {
        1 => println!("one"),
        2 => println!("two"),
        3 => println!("three"),
        _ => println!("anything"),
    }
}
```

```rs
// while let 条件循环
fn main() {
    let mut stack = Vec::new();

    stack.push(1);
    stack.push(2);
    stack.push(3);

    while let Some(top) = stack.pop() { // refutable 模式
        println!("{}", top);
    }
}
```

```rs
// for Loops
fn main() {
    let v = vec!['a', 'b', 'c'];

    for (index, value) in v.iter().enumerate() {
        println!("{} is at index {}", value, index);
    }
}

```

```rs
// 声明也是一种模式匹配，并且是一种 irrefutable 模式
// let PATTERN = EXPRESSION;
let x = 5;
```

```rs
// 函数输入参数重的模式匹配
fn print_coordinates_1((x, y): (i32, i32)) {
    println!("Current location: ({}, {})", x, y);
}
fn print_coordinates_2(x: i32, y: i32) {
    println!("Current location: ({}, {})", x, y);
}
fn main() {
    let point = (3, 5);
    print_coordinates_1(point);
    print_coordinates_2(3, 5);
}
```

```rs
// match 模式匹配会生成新的作用域
fn main() {
    let x = Some(5);
    let y = 10;

    match x {
        Some(50) => println!("Got 50"),
        Some(y) => println!("Matched, y = {:?}", y), // y变量会被重影，这里的y变量值为5
        _ => println!("Default case, x = {:?}", x),
    }

    println!("at the end: x = {:?}, y = {:?}", x, y);
}
```

```rs
// 通过 | 匹配多种可能性
fn main() {
    let x = 1;

    match x {
        1 | 2 => println!("one or two"),
        3 => println!("three"),
        _ => println!("anything"),
    }
}

```

```rs
// 范围匹配 ..= // 只能匹配数字或字符
fn main() {
    let x = 5;
    match x {
        1..=5 => println!("one through five"),
        _ => println!("something else"),
    }

    let x = 'c';
    match x {
        'a'..='j' => println!("early ASCII letter"),
        'k'..='z' => println!("late ASCII letter"),
        _ => println!("something else"),
    }
}
```

```rs
// 解构结构体进行模式匹配
struct Point {
    x: i32,
    y: i32,
}

fn main() {
    let p = Point { x: 0, y: 7 };
    // 方式一
    let Point { x: a, y: b } = p;
    assert_eq!(0, a);
    assert_eq!(7, b);
    // 方式二 // 简写模式，通过变量名称与字段名称相匹配，然后进行赋值
    let Point { x, y } = p;
    assert_eq!(0, x);
    assert_eq!(7, y);
    // 方式三
    match p {
        Point { x, y: 0 } => println!("On the x axis at {}", x),
        Point { x: 0, y } => println!("On the y axis at {}", y),
        Point { x, y } => println!("On neither axis: ({}, {})", x, y),
    }
}
```

```rs
// 解构枚举进行模式匹配
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

fn main() {
    let msg = Message::ChangeColor(0, 160, 255);

    match msg {
        Message::Quit => {
            println!("The Quit variant has no data to destructure.")
        }
        Message::Move { x, y } => {
            println!(
                "Move in the x direction {} and in the y direction {}",
                x, y
            );
        }
        Message::Write(text) => println!("Text message: {}", text),
        Message::ChangeColor(r, g, b) => println!(
            "Change the color to red {}, green {}, and blue {}",
            r, g, b
        ),
    }
}
```

```rs
// 解构嵌套的枚举或结构体进行模式匹配
enum Color {
    Rgb(i32, i32, i32),
    Hsv(i32, i32, i32),
}

enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(Color),
}

fn main() {
    let msg = Message::ChangeColor(Color::Hsv(0, 160, 255));

    match msg {
        Message::ChangeColor(Color::Rgb(r, g, b)) => println!(
            "Change the color to red {}, green {}, and blue {}",
            r, g, b
        ),
        Message::ChangeColor(Color::Hsv(h, s, v)) => println!(
            "Change the color to hue {}, saturation {}, and value {}",
            h, s, v
        ),
        _ => (),
    }
}
```

```rs
// 函数输入参数忽视变量值的模式匹配
fn foo(_: i32, y: i32) {
    println!("This code only uses the y parameter: {}", y);
}

fn main() {
    foo(3, 4);
}
```

```rs
// match 忽视变量值的模式匹配
fn main() {
    let mut setting_value = Some(5);
    let new_setting_value = Some(10);
    match (setting_value, new_setting_value) {
        (Some(_), Some(_)) => {
            println!("Can't overwrite an existing customized value");
        }
        _ => {
            setting_value = new_setting_value;
        }
    }
    println!("setting is {:?}", setting_value);


    let numbers = (2, 4, 8, 16, 32);
    match numbers {
        (first, _, third, _, fifth) => {
            println!("Some numbers: {}, {}, {}", first, third, fifth)
        }
    }
}
```

```rs
// 忽视以 _ 开头的变量。当暂时不想使用某个变量，又不想在编译时收到警告，则可以让变量以 _ 开头。
fn main() {
    let _x = 5;
    let y = 10;
}
```

```rs
// 使用 .. 忽视一些值，一个模式匹配中只能使用一次 ..
fn main() {
    struct Point {
        x: i32,
        y: i32,
        z: i32,
    }

    let origin = Point { x: 0, y: 0, z: 0 };

    match origin {
        Point { x, .. } => println!("x is {}", x),
    }
    match origin {
        Point { x, y: _, z: _ } => println!("x is {}", x),
    }
}
```

```rs
// Match Guards
fn main() {
    let num = Some(4);

    match num {
        Some(x) if x % 2 == 0 => println!("The number {} is even", x), // 先进行模式匹配，再进行条件判断
        Some(x) => println!("The number {} is odd", x),
        None => (),
    }
}
```

```rs
// @ Bindings
// 通过@可以在模式匹配中验证 值 是否匹配某些值，如果匹配则将值赋予给新的变量
fn main() {
    enum Message {
        Hello { id: i32 },
    }

    let msg = Message::Hello { id: 5 };

    match msg {
        Message::Hello {
            id: id_variable @ 3..=7, // 如果 id 值在3～7的范围内，则将 id变量值 赋值给 id_variable变量值。
        } => println!("Found an id in range: {}", id_variable),
        Message::Hello { id: 10..=12 } => {
            println!("Found an id in another range")
        }
        Message::Hello { id } => println!("Found some other id: {}", id),
    }
}
```

## 五 Unsafe Rust
- safe Rust 指的是所有代码都被编译器在编译期间通过各种代码检查保证了运行时的内存安全。
- unsafe Rust 会减少编译期间的检查，将运行时的内存安全交给程序员去保障。但运行期间的Rust程序也必须遵守Rust的安全机制，例如借用规则，如果违反了则panic。

- 使用 Unsafe Rust 
    - 放弃内存安全保障
    - 获取更好的性能
    - 获取和另一门语言或者硬件进行交互的能力

- 通过``unsafe``关键字定义代码块，可以获取一下5个超能力
    1. Dereference a raw pointer 解引用原始指针
    2. Call an unsafe function or method 调用不安全的函数和方法
    3. Access or modify a mutable static variable 访问或修改一个可变的静态变量
    4. Implement an unsafe trait 实现不安全的特征
    5. Access fields of unions 访问union字段。union主要用于和C语言的对接。

```rs
fn main() {
    let mut num = 5;
    // 通过关键字 as 创建原始指针（raw pointer） // 可以在安全代码里声明原始指针，但不能解引用
    let r1 = &num as *const i32;  // *const i32 原始指针
    let r2 = &mut num as *mut i32; //  *mut i32 原始指针
    unsafe {
        // 在关键字unsafe代码块内进行解引用
        println!("r1 is: {}", *r1);
        println!("r2 is: {}", *r2);
    }

    // 使用随机的内存地址
    let address = 0x012345usize;
    let r3 = address as *const i32;
}
```

```rs
// 调用不安全的关联函数
fn main() {
    unsafe fn dangerous() {}

    unsafe {
        dangerous();
    }
}
```
```rs
// 调用不安全的关联函数
use std::slice;

fn split_at_mut(values: &mut [i32], mid: usize) -> (&mut [i32], &mut [i32]) {
    let len = values.len();
    let ptr = values.as_mut_ptr();

    assert!(mid <= len);

    // 这里会触发编译报错。
    // 编译器认定values变量被借用了两次，编译器不能分辨出我们其实是借用了数组的不同部分。
    // 代码实际上是安全的，因此我们需要使用unsafe关键字来完成这个功能。
    // (&mut values[..mid], &mut values[mid..])

    unsafe {    // 使用unsafe的代码来完成
        (
            slice::from_raw_parts_mut(ptr, mid), // slice::from_raw_parts_mut 获取了原始指针
            slice::from_raw_parts_mut(ptr.add(mid), len - mid), // 不能确定偏移mid数量的位置后，指针依然是有效的。
        )
    }
}

fn main() {
    let mut vector = vec![1, 2, 3, 4, 5, 6];
    let (left, right) = split_at_mut(&mut vector, 3);
}
```

```rs
// 使用关键字extern调用其它语言的代码。
extern "C" { // 调用C语言的代码
    fn abs(input: i32) -> i32;
}

fn main() {
    unsafe {
        println!("Absolute value of -3 according to C: {}", abs(-3));
    }
}
```

```rs
// 通过extern关键字创建函数，让其它语言进行调用
#![allow(unused)]
fn main() {
#[no_mangle] // 禁止编译时期编译器优化更改函数名字
pub extern "C" fn call_from_c() { // 提供给C语言使用这个函数
    println!("Just called a Rust function from C!");
}
}
```

```rs
// 修改可变静态变量
static mut COUNTER: u32 = 0;

fn add_to_count(inc: u32) {
    // 修改静态变量是不符合Safe Rust安全检查的，因为可能会触发数据竞争
    unsafe {
        COUNTER += inc;
    }
}

fn main() {
    add_to_count(3);

    unsafe {
        println!("COUNTER: {}", COUNTER);
    }
}
```

```rs
// 不安全的特征
unsafe trait Foo {
    // methods go here
}

unsafe impl Foo for i32 {
    // method implementations go here
}

fn main() {}
```


## 六 深入特征
- 关联类型（associated types）是一个将类型占位符与 特征 相关联的方式。关键字 Item
- 默认泛型类型参数。
- 完全限定语法与消歧义：调用相同名称的方法。

```rs
// 在特征中使用关联类型作为占位符
#![allow(unused)]
pub trait Iterator {
    type Item; // 关联类型未定义具体的类型

    fn next(&mut self) -> Option<Self::Item>;
}
struct Counter {
    count: u32,
}

impl Counter {
    fn new() -> Counter {
        Counter { count: 0 }
    }
}

impl Iterator for Counter {
    type Item = u32; // 在这里，定义具体的类型

    fn next(&mut self) -> Option<Self::Item> {
        if self.count < 5 {
            self.count += 1;
            Some(self.count)
        } else {
            None
        }
    }
}

```

```rs
// 给 特征 的输入参数泛型定义默认的数据类型
#![allow(unused)]
fn main() {
trait Add<Rhs=Self> {
    type Output;

    fn add(self, rhs: Rhs) -> Self::Output;
}
}
```

```rs
//  完全限定无歧义调用
```

```rs
// 定义一个实现这个特征的数据类型也需要实现另外几个特征
use std::fmt;

trait OutlinePrint: fmt::Display { // 定义实现OutlinePrint特征的数据类型必须也实现了fmt::Display特征
    fn outline_print(&self) {
        let output = self.to_string();
        let len = output.len();
        println!("{}", "*".repeat(len + 4));
        println!("*{}*", " ".repeat(len + 2));
        println!("* {} *", output);
        println!("*{}*", " ".repeat(len + 2));
        println!("{}", "*".repeat(len + 4));
    }
}

fn main() {}
```

```rs
// Rust机制里的orphan rul：只要 特征 或 类型 对于当前 crate 是本地的话就可以在此类型上实现该 trait。
// 但，也可以通过 newtype pattern 模式绕过这个规则
use std::fmt;

struct Wrapper(Vec<String>); // 通过构建封装Vec<String>类型，构建一个新的类型 Wrapper

impl fmt::Display for Wrapper { // 通过新的类型 Wrapper 去实现 fmt::Display 特征
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "[{}]", self.0.join(", "))
    }
}

fn main() {
    let w = Wrapper(vec![String::from("hello"), String::from("world")]);
    println!("w = {}", w);
}

```

## 七 深入类型
- 类型别名(Type Alias)
- newtype 使用元组结构体的方式将已有的类型包裹起来
- 动态类型 = ynamically sized types = DST = 不定长类型 = unsized

```rs
// 类型别名 实例一
fn main() {
    type Kilometers = i32; // 给 i32 定义一个类型别名Kilometers

    let x: i32 = 5;
    let y: Kilometers = 5;

    println!("x + y = {}", x + y);
}
```

```rs
// 类型别名 实例二
fn main() {
    let f: Box<dyn Fn() + Send + 'static> = Box::new(|| println!("hi"));


    fn takes_long_type(f: Box<dyn Fn() + Send + 'static>) {}
    fn returns_long_type() -> Box<dyn Fn() + Send + 'static> {
        Box::new(|| ())
    }

    // 通过别类型名让代码看起来更易于阅读
    type Thunk = Box<dyn Fn() + Send + 'static>;
    let f: Thunk = Box::new(|| println!("hi"));
    fn takes_long_type(f: Thunk) {}

    fn returns_long_type() -> Thunk {
        Box::new(|| ())
    }
}
```

```rs
// 特殊的类型()
fn fn_name_1(){
    // --snip--
}
fn fn_name_1() -> (){
    // --snip--
}
```


```rs
// 动态类型
fn generic_1<T: Sized>(t: T) {
    // --snip--
}
// 泛型T 的大小是未知的
fn generic_1<T: ?Sized>(t: &T) {
    // --snip--
}

// Box<dyn Trait>  // 特征 是动态类型
```

## 八 函数和闭包
```rs
// 函数作为参数，参数类型为fn，被命名为function pointer
fn add_one(x: i32) -> i32 {
    x + 1
}

fn do_twice(f: fn(i32) -> i32, arg: i32) -> i32 {
    f(arg) + f(arg)
}

fn main() {
    let answer = do_twice(add_one, 5);

    println!("The answer is: {}", answer);
}
```

```rs
// function pointer 类型，既可以传 函数 也可以传 闭包
fn main1() {
    // 传递闭包进.map()里
    let list_of_numbers = vec![1, 2, 3];
    let list_of_strings: Vec<String> =
        list_of_numbers.iter().map(|i| i.to_string()).collect();
}
fn main2() {
    // 传递函数进.map()里
    let list_of_numbers = vec![1, 2, 3];
    let list_of_strings: Vec<String> =
        list_of_numbers.iter().map(ToString::to_string).collect(); 
}
```

```rs
// 闭包和创建变量
fn main() {
    #[derive(Debug)]
    enum Status {
        Value(u32),
        Stop,
    }
    // 通过传递function pointer来创建变量
    let list_of_statuses_1: Vec<Status> = (0u32..20).map(Status::Value).collect();

    // 传统的创建变量方式
    let mut list_of_statuses_2: Vec<Status> = Vec::new();
    for i in (0u32..20){
        list_of_statuses_2.push(Status::Value(i));
    }

    println!("{:?}", list_of_statuses_1);
    println!("{:?}", list_of_statuses_2);
}
```

```rs
// 闭包的表示形式为特征。

// 直接返回 特征会 报错，因为编译器不知道闭包的内存占用大小
// fn returns_closure() -> dyn Fn(i32) -> i32 {
//     |x| x + 1
// }

// 将 特征 封装进特定的数据类型里，再进行返回
fn returns_closure() -> Box<dyn Fn(i32) -> i32> {
    Box::new(|x| x + 1)
}
```

## 其它
### 引用类型的两种定义方式
- &
- ref
```rs
fn main() {
    let s = Some(String::from("Hello!"));
    match s {
        // 通过 ref 关键字，定义 t 变量是引用类型变量，因此s的所有权没有被转移
        // 在这里只能使用 ref 关键声明 t 变量是引用类型
        Some(ref t) => println!("t = {}", t),
        _ => {}
    }
    println!("s = {}", s.unwrap());
}
```

### 转义
- 通过 `` r#"内容" `` 的方式定义字符串字面量，免除使用\特殊符号进行转义。
```rs
"foo"; r"foo";                     // foo
"\"foo\""; r#""foo""#;             // "foo"

"foo #\"# bar";
r##"foo #"# bar"##;                // foo #"# bar

"\x52"; "R"; r"R";                 // R
"\\x52"; r"\x52";                  // \x52
```

```rs
fn main(){
    let data = r#"
        {
            "name": "John Doe",
            "age": 43,
            "phones": [
                "+44 1234567",
                "+44 2345678"
            ]
        }"#;
}

```