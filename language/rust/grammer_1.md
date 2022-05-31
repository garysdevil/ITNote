[TOC]
## 基本语法
- Rust 是强类型语言

### hello world
```bash
vim hello.rs
rustc hello.rs
./hello
```
```rs
fn main() {
    // 在输出字符串里，{} 大括号表示占位符
    println!("Hello World! \n--{0},{0},{1}", "Gary1", "Gary2");
}
```

### 声明变量
- 
```rust
// 如果要声明变量，必须使用 let 关键字。
// let 关键字声明的变量，默认是不可以被改变的。
// 如果在代码里未指定变量的数据类型，则编译时编译器会根据变量的值推断出变量的数据类型。
let var_name1 = 123; 

// 重影：变量的名称可以被重新使用的机制，即变量的值可以被重新绑定。
let var_name1 = "aa";

// 如果要声明变量时指定变量的类型，必须在变量后面使用 : 关键字。
let var_name1:u8 = 123; 

// 如果要声明可变的变量，必须使用 mut 关键字。
let mut var_name2 = 123;
var_name2 = 234;

// 使用声明常量，必须使用 const 关键字。
// 常量不能被重影。
const const_name1: i32 = 123;
```

### 数据类型
- 基本数据类型
    - 所有整数类型，例如 i32 、 u32 、 i64 等。
    - 布尔类型 bool，值为 true 或 false 。
    - 所有浮点类型，f32 和 f64。
    - 字符类型 char。
    - 仅包含以上类型数据的元组（Tuples）。

1. 整数型
    ```rust
    // - 有符号8 bit整形 i8
    let var_name1: i8 = 11;
    // - 无符号8 bit整形 u8
    let var_name2: u8 = 22;
    // ...
    ```

2. 浮点数型
    - 只有 32 位浮点数（f32）和 64 位浮点数（f64）。
    ```rust
    let var_name1: f32 = 3.0; // f32
    ```

3. 布尔型
    ```rust
    let var_name1: bool = true;
    ```

4. 字符型
    - 字符型大小为 4 个字节
    ```rust
    let var_name1: char = '我';
    let var_name1 = '😻';
    let var_name1 = '❤';
    ```

5. 复合类型=元组
    - 一个变量可以包含不同类型的数据
    ```rust
    let tuples_name: (i32, f64, u8) = (500, 6.4, 1);
    let (x, y, z) = tuples_name;
    ```

6. 数组
    ```rust
    let arr_name1 = [1, 2, 3, 4, 5];
    let arr_name1: [i32; 5] = [1, 2, 3, 4, 5];
    // 可以通过 数组.iter() 方式进行数组的迭代
    arr_name1.iter()
    ```

7. 字符串
    ```rust
    let var_stack_name = String::from("garysdevil");
    ```

8. 切片
    - 切片（Slice）是对数据值的部分引用。
    - 切片的结果是 &str 类型的数据，&str也称为字符串字面量或字符串切片。
    - &str是一种不可变引用，因此变量值不能被更改。
    ```rust
    fn main() {
        // 声明一个 &str 类型的数据
        let var_slice_name = "hello";
        // 将字符串字面量转换为字符串对象
        var_slice_name.to_string();

        // 切片
        let mut var_string_name = String::from("garyadam");
        let var_slice_name1 = &var_string_name[0..4];
        let var_slice_name2  = &var_string_name[4..8];
        println!("{}={}+{}", var_string_name, var_slice_name1, var_slice_name2);
        // 切片
        let var_arr = [1, 3, 5, 7, 9];
        let var_slice_name3 = &var_arr[0..3];
    }
    ```

## 流程控制
- if else 是基于 true和false
- match 是基于模式匹配
### 条件 if else
```rust
fn main() {
    let var_number1 = 3;
    if var_number1 < 5 {
        println!("条件为 true");
    } else {
        println!("条件为 false");
    }
    // 三元表达式
    let var_number2 = if var_number1 > 0 { 1 } else { -1 };
    println!("var_number 为 {}", var_number2);
}
```
### 分支选择 match
- match 能够对枚举类、整数、浮点数、字符、字符串切片引用（&str）类型的数据进行分支选择
- 关键字 match 实现分支结构，类似于Java的switch
- if let 语法， 是只区分两种情况的 match 语句的"语法糖"

```rust
fn main() {
    // 例子一
    let var_str = "abc";
    match var_str {
        "abc" => println!("Yes"),
        _ => { println!("No") },
    }
    if let "abc" = var_str {
        println!("Yes");
    }else{
        println!("No")
    }

    // 例子二 
    let var_name = Some(9);   
    if let Some(temp) = var_name {  // 如果 var_name模式匹配成功，则会被赋值给temp变量
        println!("{}", temp);  
    }
    if let Some(9) = var_name {
        println!("{}", temp);  
    }
    if let Some(3) = var_name {
        println!("{}", temp);  
    }

    // 例子三
    enum Book {
        Number(u32),
        Electronic(String)
    }
    let book = Book::Number(1001);
    if let Book::Number(index) = book {
        println!("Number {}", index);
    } else {
        println!("Can't find number");
    }
}
```

### 循环
```rust
// while 循环
fn fun_while() {
    let mut var_number = 1;
    while var_number != 4 {
        println!("{}", var_number);
        var_number += 1;
    }
    println!("EXIT");
}

// 没有 for 的三元语句控制循环，例如 for (i = 0; i < 10; i++)

// for 循环遍历数组
fn fun_for() {
    let array = [10, 20, 30, 40, 50];
    for value in array.iter() {
        println!("值为 : {}", value);
    }
    for i in 0..5 {
        println!("array[{}] = {}", i, array[i]);
    }
}

// loop 无限循环
// loop 无限循环体内，可以通过break结束循环，然后返回一个值
fn fun_loop() {
    let array = ['A', 'B', 'C', 'D'];
    let mut i = 0;
    let location = loop {
        let character = array[i];
        if character == 'C' {
            break i;
        }
        i += 1;
    };
    println!("字母 \'C\' 的索引为 {}", location);
}
```

## 函数
```rust
// 如果要声明函数，必须使用 fn 关键字。
// 如果函数需要输入参数，必须填写参数名称和类型。
fn function_name(x: i32, y: i32) {
    println!("x 的值为 : {}", x);
    println!("y 的值为 : {}", y);
}

// 如果需要返回数据，必须使用 -> 关键字，并且声明返回的数据类型。
fn add(x: i32, y: i32) -> i32 {
    return x + y;
}
fn main(){
    function_name(1,2);
}
```

## 所有权&引用
- 基于以下三条规则形成所有权
    - 每个值都有一个变量，称为其所有者。
    - 一次只能有一个所有者。
    - 当所有者不在程序运行范围时，该值将被删除。

### 变量有效范围
```rust
{
    // 在声明以前，变量 var_name 无效
    let var_name = "garysdevil";
    // 这里是变量 var_name 的有效范围
}
// 变量有效范围结束，变量 var_name 被释放
```

### 内存分配/内存释放
- 如果我们需要储存的数据长度不确定（比如用户输入的一串字符串），我们就无法在定义时明确数据长度，也就无法在编译阶段让程序分配固定长度的内存空间供数据储存使用。因此编程语言会提供一种在程序运行时程序自己申请使用内存的机制，堆。
- 内存的释放
    - 在C语言机制中，可以调用free(变量名)，来释放内存。
    - 在java语言机制中，通过运行时垃圾回收机制释放，对性能产生一定的影响。
    - 在Rust语言机制中，当变量有效范围结束时，Rust 编译器自动添加调用释放资源函数的步骤。

### 堆数据的移动

- 堆变量间的相互赋值，将导致数据的移动
    ```rust
    // 基本数据类型都存储在栈中，变量值被复制给var_name2
    let var_name1 = 5;
    let var_name2 = var_name1;

    // 非基本数据类型的数据，存储在堆中。var_stack_name2指向var_stack_name1的数据值，var_stack_name1被释放。
    let var_stack_name1 = String::from("hello");
    let var_stack_name2 = var_stack_name1; // var_stack_name1 被内存释放
    println!("{}, world!", var_stack_name1); // 错误！var_stack_name1 已经失效
    ```

- 函数传递的输入参数/输出参数存储在堆里时，将导致数据的移动
    ```rust
    fn main() {
        let var_stack_name1 = String::from("hello");
        // var_stack_name1 是非基本数据类型，作为参数传入函数，var_stack_name1 被内存释放。
        func_name1(var_stack_name1);

        // var_name1 是基本数据类型，作为参数传入函数，var_name1 数据被复制了一份传入，var_name1不被释放。
        let var_name1 = 5;
        func_name2(var_name1);
    }

    fn func_name1(some_string: String) {
        // 一个 String 参数 some_string 传入，有效
        println!("{}", some_string);
    } // 函数结束, some_string 在这里被释放

    fn func_name2(some_integer: i32) -> i32 {
        // 一个 i32 参数 some_integer 传入，有效
        println!("{}", some_integer);
    } // 函数结束, 参数 some_integer 是基本类型, 无需释放 ???疑惑
    ```

### 堆数据的克隆
```rust
// 通过数据克隆，堆变量值不会被移除
let var_stack_name1 = String::from("hello");
let var_stack_name2 = var_stack_name1.clone();
// let var_name2 = var_stack_name1; 如果直接通过这种方式赋值，将导致对数据的移动，var_stack_name1将被释放，下面的语句将会报错。
println!("var_stack_name1 = {}, s2 = {}", var_stack_name1, var_stack_name2);
```

### 堆数据的引用
- 引用符号：&
- 如果A引用了B，则A的地址会指向B的地址。
- 引用、借用、租借 是相同的概念。
- 引用的所有权
    - 引用不会获取值的所有权。
    - 引用只是租借值的所有权。

- 可变引用不允许多重引用。意味着当可变引用未被释放时，所有者不能更改值或者对值进行其它操作。

- 所有权机制的优点
    - 解决数据共享冲突问题，垂悬指针问题。
    - 引用指向的地址背后的堆数据为空，则编译时报错。（避免空指针问题）

```rust
fn func_immutable_reference(){
    let var_stack_name1 = String::from("adam");
    let var_stack_name2 = &var_stack_name1; // var_stack_name2可以理解为var_stack_name1的软链接
    println!("var_stack_name1 is {}, var_stack_name2 is {}", var_stack_name1, var_stack_name2);
    let var_stack_name3 = var_stack_name1; // var_stack_name1的数据所有权被转移了， 之前的var_stack_name1相关的引用失效。
    let var_stack_name2 = &var_stack_name3; // var_stack_name1 租借 var_stack_name3 的所有权
}

fn func_mutable_reference(){
    let mut var_stack_name1 = String::from("AA-");
    let mut var_stack_name2 = &mut var_stack_name1; // var_stack_name2 是可变的引用

    var_stack_name2.push_str("BB-");
    println!("var_stack_name2 is {}", var_stack_name2);
    // 当 var_stack_name2 在函数内不在被使用，则 租借所有权结束
    
}
```

## 结构体

### 结构体
- 关键字 struct
```rust
// 结构体定义
#[derive(Debug)]
struct Person {
    name: String,
    nickname: String,
    age: u32
}
fn func_strcut() {
    // 创建结构体实例
    let gary = Person {
        name: String::from("gary"),
        nickname: String::from("garysdevil"),
        age: 18
    };
    // 创建结构体实例，更改个别属性值，其它属性值从一个结构体实例里移植过来
    let newgary = Person {
        age: 19,
        ..gary // 进行移植操作
    };
    println!("gary is {}", gary.age);
    println!("newgary is {:?}", newgary); // 通过调试库 #[derive(Debug)]，输出一整个结构体

    // 元组结构体
    struct Color(u8, u8, u8); // 定义元组结构体
    let struct_black = Color(0, 0, 0); // 实例化元组结构体
    println!("black = ({}, {}, {})", struct_black.0, struct_black.1, struct_black.2);
}
```

### 结构体方法
- 关键字 impl
```rust
struct Rectangle {
    width: u32,
    height: u32,
}

// 定义结构体方法时，struct关键字定义的名字 和 impl关键字定义的名字必须相同
// 注意： 结构体方法的第一个参数必须是 &self，代表调用者
// 调用： 结构体方法需要结构体实例来调用。
impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }
    fn wider(&self, rect: &Rectangle) -> bool {
        self.width > rect.width
    }
}

fn main() {
    let rect1 = Rectangle { width: 30, height: 50 };
    let rect2 = Rectangle { width: 40, height: 20 };
    println!("rect1's area is {}", rect1.area());
    println!("{}", rect1.wider(&rect2));
}
```

### 结构体关联函数
```rust
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

// 定义结构体关联函数时，struct关键字定义的名字 和 impl关键字定义的名字必须相同.
// 注意： 结构体关联函数的返回数据必须是结构体。String::from() 就是一个结构体关联函数
// 调用： 使用结构体名称进行调用。
impl Rectangle {
    fn create(width: u32, height: u32) -> Rectangle {
        Rectangle { width, height }
    }
}

fn main() {
    // 使用结构体关联函数
    let rect = Rectangle::create(30, 50);
    println!("{:?}", rect);
}
```

## 枚举
- Rust世界里，Null 和 异常 都使用特殊的枚举类来处理。

### 枚举的定义 enum
```rust

// 定义一个枚举类型
#[derive(Debug)]
enum Book {
    Papery,
    Number(u32), // 枚举类成员添加元组属性
    Electronic { url: String }, // 枚举类成员添加结构体属性；如果要为属性命名，则需要使用结构体语法
}

fn main() {

    let book1 = Book::Papery; // 实例化枚举
    let book2 = Book::Number(1001); // 实例化枚举
    let book3 = Book::Electronic{url: String::from("garys.top")}; // 实例化枚举

    
    println!("{:?}", book1);
    println!("{:?}", book2);
    println!("{:?}", book3);

    match book1 { // match 语句实现分支结构，类似于Java的switch
        Book::Papery => {
            println!("This book is papery");
        },
        Book::Number( index ) => { // 如果枚举类成员拥有元组属性，则临时指定一个参数名字
            println!("Number book {}", index);
        },
        Book::Electronic { url } => {
            println!("E-book {}", url);
        }
    }
}

```

### 特殊的枚举 Option
- Option 是 Rust 标准库中的枚举类，这个类用于填补 Rust 不支持 null 引用的空白。
- 一般当值可能有也可能无时，使用 Option。
- Option要么是一个Some中包含一个值，要么是一个None；对应Option::Some(value)和Option::None。

```rust
// Option枚举的基本形式
pub enum Option<T> {
    None,
    Some(T),
}
```

```rust
fn main() {
    let var_enum_name1 = Option::Some("Hello"); // 定义一个Option枚举

    // 如果使用None而不是Some时，需要告诉编译器Option<T>的类型。
    let var_enum_name2: Option<&str> = Option::None; // 定义一个Option空枚举

    match var_enum_name2 {
        Option::Some(something) => {
            println!("{}", something);
        },
        Option::None => {
            println!("var_enum_name2 is nothing");
        }
    }

    // 通过 unwarp 方法获取 Some(x) 中 的 x 值。当值是None是则会报错。
    println!("{}", var_enum_name2.unwrap());


}
```

### 特殊的枚举 Result
- 在 Rust 中通过 Result<T, E> 枚举类作返回值来进行异常处理。
- 在 Rust 标准库中可能产生异常的函数的返回值都是 Result 枚举类型的，最常见的使用是在IO操作中。
- 一般可能产生可以恢复的错误时，都使用Result作为返回值。


- 异常
    ```rust
    enum Result<T, E> {
        Ok(T),
        Err(E),
    }
    ```

- 错误处理
    ```rust
    use std::fs::File;

    fn main() {
        // 可恢复错误
        let f = File::open("./hello.txt");
        if let Ok(file) = f {
            println!("File opened successfully.");
        } else {
            println!("Failed to open the file.");
        }

        // 抛出异常，程序终止
        // panic!("error occured");

        // 可恢复错误按不可恢复错误处理，直接抛出异常程序终止
        File::open("hello.txt").unwrap(); // 方式一
        File::open("hello.txt").expect("Failed to open."); // 方式二
        assert!(File::open("hello.txt").is_ok()); // 方式三
        }
    ```

- 错误的传递
    ```rust
    // 可恢复错误的传递
    fn func_judge(i: i32) -> Result<i32, bool> { // 判断一个数字是否大于0
        if i >= 0 { Ok(i) }
        else { Err(false) }
    }

    fn func_name(i: i32) -> Result<i32, bool> {
        // 传递错误 方式一
        // let result = func_judge(i);
        // return match result {
        //     Ok(i) => Ok(i),
        //     Err(b) => Err(b)
        // };
        
        // 传递错误 方式二
        // Rust 中可以在 Result 对象后添加 ? 操作符将同类的 Err 直接传递出去
        let result = func_judge(i)?;
        Ok(result) // 因为确定 t 不是 Err, t 在这里已经是 i32 类型
    }

    fn main() {
        let result = func_name(10000);
        if let Ok(v) = result {
            println!("Ok: g(10000) = {}", v);
        } else {
            println!("Err");
        }
    }
    ```

## 组织管理
- 包 Package
    - 当使用 Cargo 执行 new 命令创建 Rust 工程时，工程目录下会建立一个 Cargo.toml 文件。工程的实质就是一个包，包必须由一个 Cargo.toml 文件来管理，该文件描述了包的基本信息以及依赖项。
- 箱
    - "箱"是二进制程序文件或者库文件，存在于"包"中。

- 模块
    - 关键字 mod

### 模块
- 默认文件名字即为模块的名字。

- 权限
    - 对于 模块、函数、结构体、结构体属性，不加pub修饰符，则默认是私有的。
    - 对于私有的，只有在与其平级的位置或下级的位置才能访问，不能从其外部访问。

- use 关键字能够将模块标识符引入当前作用域

- 内置的标准模块（标准库） https://doc.rust-lang.org/stable/std/all.html

```rust
// vi phone_module.rs
pub fn message() -> String {
    String::from("执行发送信息的功能")
}
```
```rust
// mod phone_module; // 引用其它文件内的模块，
mod person_module {
    pub mod mouth {
        pub fn eat() { println!("执行吃的功能") }
    }
    // hand模块没有pub修饰符，只能被平级或者下级的位置访问
    mod hand {
        pub fn hit() { println!("执行击打的功能") }
    }
    pub mod head {
        pub fn action() {
            super::hand::hit();
        }
    }
}

fn main() {
    // 调用模块里的函数
    person_module::head::action(); // 相对路径调用
    crate::person_module::head::action(); // 绝对路径调用

    use crate::person_module::mouth::eat; // 把 eat 标识符导入到了当前的模块下，然后可以直接使用
    use crate::person_module::mouth::eat as person_eat; // 把 eat 标识符导入到了当前的模块下，并且添加一个别名
    eat();
    person_eat();

    // println!("{}", phone_module::message()); 

    // 引用标准库 std下的PI
    use std::f64::consts::PI;
    println!("{}", (PI / 2.0).sin());
}
```

## 泛型&特性
### 泛型
- 泛型机制是编程语言用于表达类型抽象的机制，一般用于功能确定、数据类型待定的类，如链表、映射表等。

- 函数范型
    ```rust
    // 函数范型
    fn func_return_first<T>(array: &[T]) -> &T {
        return &array[0];
    }
    fn main() {
        let array = [1.1, 2.2, 3.3, 4.4];
        println!("array[0] = {}", func_return_first(&array));
    }
    ```

- 枚举范型
    ```rust
    // 枚举范型
    enum Option<T> {
        Some(T),
        None,
    }
    enum Result<T, E> {
        Ok(T),
        Err(E),
    }
    ```

- 结构体范型
    ```rust
    // 结构体范型
    struct Point<T> {
        x: T,
        y: T
    }
    // 结构体方法范型
    impl<T> Point<T> {
        fn func_return_x(&self) -> &T {
            &self.x
        }
    }
    fn main() {
        let p = Point { x: 1, y: 2 };
        println!("p.x = {}", p.x());
    }
    ```

- where 关键字
    ```rust
    // 复杂的实现关系可以使用 where 关键字简化
    // 例如：T数据类型必须实现了Display和Clone特性，U数据类型必须实现了Clone和Debug特性
    fn some_function<T: Display + Clone, U: Clone + Debug>(t: T, u: U) -> i32
    // 另一种表达方式
    fn some_function<T, U>(t: T, u: U) -> i32
        where T: Display + Clone,
            U: Clone + Debug
    ```

### 特性
- 特性（trait）概念接近于 Java 中的接口（Interface），但两者不完全相同。
- 特性与接口相同的地方在于它们都是一种行为规范，可以用于标识哪些类/结构体有哪些方法。
- 特性里既可以定义接口（没有方法体的方法），也可以定义方法。
```rust
// 定义特性
trait Behaviour {
    fn describe(&self) -> String {
        String::from("[Object]")
    }
    fn say(&self);
}

struct Person {
    name: String,
    age: u8
}

// 结构体Person重写特性定义的方法describe
impl Behaviour for Person {
    fn describe(&self) -> String {
        format!("{} {}", self.name, self.age)
    }
    fn say(&self) {
        println!("iloveyou");
    }
}

pub fn local_fn() {
    let cali = Person {
        name: String::from("Cali"),
        age: 24
    };
    println!("{}", cali.describe());
}
```

### 范型与特性
```rust
// 定义一个特性
trait Comparable {
    fn compare(&self, object: &Self) -> i8;
}

// 定义一个方法；输入参数 为 范型数据类型，并且该范型数据类型必须实现了Comparable特性
fn max<T: Comparable>(array: &[T]) -> &T {
    let mut max_index = 0;
    let mut i = 1;
    while i < array.len() {
        if array[i].compare(&array[max_index]) > 0 {
            max_index = i;
        }
        i += 1;
    }
    &array[max_index]
}

// f64的数据类型实现Comparable特性
impl Comparable for f64 {
    fn compare(&self, object: &f64) -> i8 {
        if &self > &object { 1 }
        else if &self == &object { 0 }
        else { -1 }
    }
}

fn main() {
    let arr = [1.0, 3.0, 5.0, 4.0, 2.0];
    println!("maximum of arr is {}", max(&arr));
}
```
 
## 生命周期
1. 程序中每个变量都有一个固定的作用域，当超出变量的作用域以后，变量就会被销毁。变量在作用域中从初始化到销毁的整个过程称之为生命周期。
2. rust 中的借用是指对一块内存空间的引用。rust 有一条借用规则是借用方的生命周期不能比出借方的生命周期还要长。
3. 对于一个参数和返回值都包含引用的函数而言，该函数的参数是出借方，函数返回值所绑定到的那个变量就是借用方。
4. 生命周期注释是描述引用生命周期的办法。对函数的参数和返回值都进行生命周期注释，是告知编译器借用方和出借方的生命周期一样。

- 生命周期注释用单引号开头，跟着一个小写字母单词：
    - &i32        // 常规引用
    - &'a i32     // 含有生命周期注释的引用
    - &'a mut i32 // 可变型含有生命周期注释的引用

- 特殊的生命周期注释
    - &i32          // 常规引用
    - &'static str  // 含有'static生命周期注释的引用，则该引用的存活时间和该运行程序一样长。

````rust
// fun_longer函数在在编译期间将报错，因为返回值引用可能会返回过期的引用，rust机制不允许任何可能的意外发生
// fn fun_longer(var_string_1: &str, var_string_2: &str) -> &str {
//     if var_string_2.len() > var_string_1.len() {
//         var_string_2
//     } else {
//         var_string_1
//     }
// }

fn fun_longer_life<'a>(var_string_1: &'a str, var_string_2: &'a str) -> &'a str {
    if var_string_2.len() > var_string_1.len() {
        var_string_2
    } else {
        var_string_1
    }
}

fn main() {
    let result;
    {
        let var_string_1 = "rust";
        let var_string_2 = "ecmascript";
        result = fun_longer_life(var_string_1, var_string_2);
    }
    println!("{} is longer", result);
}
````


```rust
// 符串字面面具有 'static 生命周期
fn fn_main(){
    // let mark_twain: &str = "Samuel Clemens";
    let mark_twain = "Samuel Clemens";
    print_author(mark_twain);
}
// fn print_author(author: &'static str) {
fn print_author(author: &str) {
    println!("{}", author);
}
```

```rust
// 出自于 Rust 圣经 的一段程序
// 同时使用了泛型、特性、生命周期机制
// T 范型
// 'a 生命周期
// T 数据类型必须实现了 Display特性
use std::fmt::Display;

fn longest_with_an_announcement<'a, T>(x: &'a str, y: &'a str, ann: T) -> &'a str
    where T: Display
{
    println!("Announcement! {}", ann);
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
```

## 输入输出
- 接收命令行参数
    ```rust
    fn main() {
        let args = std::env::args();
        // println!("{:?}", args);
        for arg in args {
            println!("{}", arg);
        }
    }
    ```

- 命令行输入
    ```rust
    use std::io::stdin;

    fn main() {
    let mut str_buf = String::new();

        stdin().read_line(&mut str_buf)
            .expect("Failed to read line.");

        println!("Your input line is \n{}", str_buf);
    }
    ```

- 文件读取与写入
    ```rust
    use std::fs;
    use std::io::prelude::*;

    fn main() {

        // fs::write("./text.txt", "I am Gary Adam").unwrap();

        let mut file = fs::File::create("./text.txt").unwrap();
        file.write(b"I am Gary Adam2").unwrap();

        let text = fs::read_to_string("./text.txt").unwrap();
        println!("{}", text);
    }
    ```
- 文件追加内容
    ```rust
    use std::io::prelude::*;
    use std::fs::OpenOptions;

    fn main() -> std::io::Result<()> {

        let mut file = OpenOptions::new()
                .append(true).open("text.txt")?;

        file.write(b" I am Gary Adam3")?;

        Ok(())
    }
    ```

## 集合&字符串
### 向量
- 向量（Vector）是一个存放多值的单数据结构，该结构将相同类型的值线性的存放在内存中。
- 向量的数据逻辑结构是线性表，在 Rust 中的表示是 Vec<T>。
```rust
fn main(){
    let mut var_vector_1: Vec<i32> = Vec::new(); // 创建类型为 i32 的空向量
    let mut var_vector_2 = vec![1, 2, 4, 8];     // 通过数组创建向量
    var_vector_2.push(16); // 添加一个元素
    var_vector_2.push(32);
    var_vector_2.push(64);
    println!("{:?}", var_vector_2);

    var_vector_1.append(&mut var_vector_2); // 将一个向量拼接到另一个向量的尾部
    println!("{:?}", var_vector_1);

    // 遍历向量
    for ele in &var_vector_2 {
        println!("{}", ele);
    }
}
```

### 映射表
- 映射表实例化后，数据类型将被固定下来。
```rust
use std::collections::HashMap;

fn main() {
    let mut map = HashMap::new();

    map.insert("color", "red"); // 插入操作
    map.insert("size", "10 m^2");
    map.entry("color").or_insert("red"); //  确定键值值不存在则执行插入操作

    map.insert("height", "170");
    if let Some(x) = map.get_mut("height") {
        *x = "180";
    }
    println!("{}", map.get("height").unwrap());
}
```

### 字符串

```rust
fn main(){
    let mut var_string = String::new(); // 声明一个字符串
    var_string.push_str("oob"); // 追加字符串切片
    var_string.push('!');       // 追加字符

    let one = 1.to_string();         // 整数转到字符串
    let float = 1.3.to_string();     // 浮点转数到字符串
    let slice = "slice".to_string(); // 字符串切片转到字符串 

    // 字符串拼接
    let s1 = String::from("AA");
    let s2 = String::from("BB");
    let s3 = String::from("CC");
    let s4 = String::from("--") + &s1 + &s2 + &s3; // 字符串拼接方式一
    println!("{}", s4);
    let s5 = format!("{}-{}-{}", s1, s2, s3); // 字符串拼接方式二 格式化拼接
    println!("{}", s5)

    // 输出字符串长度
    // 中文是 UTF-8 编码的，每个字符长 3 字节
    let var_string = String::from("中文");
    println!("{}", var_string.len());

    // 截取字符串
    let var_string = String::from("EN中文");
    println!("{}", &var_string[0..2]); // 此用法有可能肢解一个 UTF-8 字符，例如 &s[0..3]

    // 将字符串转为字符集合
    let var_string = String::from("中文");
    let mut var_chars = var_string.chars();
    println!("{}", var_chars.count()); // 字符集合统计字符的数量；变量值会被移动
    println!("{}", var_chars.nth(2)); // 通过下标，取出一个字符集合的值

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

## 并发编程
- 主线程的结束，spawn 线程也随之结束。
- join 方法可以使子线程运行结束后再停止运行程序。
- 在所有权机制中，默认禁止子线程使用当前函数的资源，但可以使用 move 关键字来撤销禁止

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

    // 关键字move的作用是将所引用的变量的所有权转移至闭包内，通常用于使闭包的生命周期大于所捕获的变量的原生命周期
    let var_string = "hello";
    let handle = thread::spawn(move || {
        println!("{}", var_string);
    });
    handle.join().unwrap();
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

## 标准库
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

## Rust的异同
- rust编程语言里 不支持 ++ 和 -- 的数学运算符号。

- rust编程语言里 没有 for 的三元语句控制循环，例如 for (i = 0; i < 10; i++)

- () 是一种特殊的类型，值只有一个就是() 
    - https://doc.rust-lang.org/std/primitive.unit.html