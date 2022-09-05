[TOC]
## 一 基本语法
- Rust 是强类型语言

### hello world
```bash
vim hello.rs
rustc hello.rs
./hello
```
```rs
fn main() {
    println!("Hello World!"); // 标准输出
    eprintln!("standard error"); // 标准错误输出
    // 在输出字符串里，{} 大括号表示占位符
    println!("{}", "Hello World!");
    println!("Hello World! \n--{0},{0},{1}", "Gary1", "Gary2");

    // dbg宏 输出数据并且返回数据
    dbg!("hello");
    dbg!(&"hello"); // 假如变量未实现Clone特征，又不想转移所有权，则可以在变量前添加&符号从而不会转移所有权。
}
```

### 声明变量
1. 要声明变量，必须使用 let 关键字。
2. **变量默认是不能被改变的。**
3. 如果在代码里未指定变量的数据类型，则编译时编译器会根据变量的值推断出变量的数据类型。

```rust
fn main(){
    let var_name1 = 123; 

    // shadowed 重影：变量的名称可以被重新使用的机制，即变量的值可以被重新绑定。
    let var_name1 = "aa";

    // 如果要声明变量时指定变量的类型，必须在变量后面使用 : 关键字。
    let var_name1: u8 = 123; 

    // 如果要声明可变的变量，必须使用 mut 关键字。
    let mut var_name2 = 123;
    var_name2 = 234;
}
// 声明常量，必须使用 const 关键字。
// 常量不能被重影。
const CONST_NUM: i32 = 123;

// 全局变量声明，必须是要static关键字。
static mut STATIC_NUM: i32 = 123;
```

### 基本数据类型
- 基本数据类型
    1. 所有整数类型，例如 i32 、 u32 、 i64 等。 默认为 i32 类型。
    2. 布尔类型 bool，值为 true 或 false 。
    3. 所有浮点类型，f32 和 f64。默认为 f64 类型。
    4. 字符类型 char。
    5. 仅包含以上类型数据的元组（Tuples）。

1. 整数型
    -  有符号8 bit整形，取值范围 2<sup>8</sup> - 1，即0到127
    -  无符号8 bit整形，取值范围 -(2<sup>7-1</sup>) 到 2<sup>7</sup>-1，即-128到127
    ```rust
    // - 有符号8 bit整形 i32
    let var_name1: i32 = 10000;
    let var_name1: i32 = 1_0000; // 1_0000 和 10000 效果等同，1_0000 更易于阅读
    // - 无符号8 bit整形 u32
    let var_name2: u32 = 22;
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
    - 字符型大小为 4 个字节。
    ```rust
    // 使用单引号声明字符型变量
    let var_name1: char = '我';
    let var_name1 = '😻';
    let var_name1 = '❤';
    ```

5. 元组
    ```rs
    let var_tuple = (1, 2, 3)
    ```

6. 字节
    ```rs
    let var_char = 'C'; // char类型
    let var_string = "C"; // 字符串
    let var_byte = b'C'; // byte型（u8型）
    let var_bytes = b"ABC"; // byte型（&[u8; 3]）
    dbg!(var_byte); // 输出数字65
    dbg!(var_bytes); // 输出数字65
    ```



### 复合数据类型
1. 元组
    - 一个变量可以包含不同类型的数据
    ```rust
    let tuple_name: (i32, f64, u8) = (500, 6.4, 1);
    let x = tuple_name.0; // 通过索引获取元组的值

    let (x, y, z) = tuple_name; // 分解元组

    let tupple_special_name = (); // 这是一个特殊的元组，unit type 
    ```

2. 数组
    ```rust
    let arr_name1: [i32; 5] = [1, 2, 3, 4, 5];
    let arr_name1 = [1, 2, 3, 4, 5];
    let arr_name1 = [3; 5]; // 等同于 let arr_name1 = [3, 3, 3, 3, 3]; 

    let element = arr_name1[0]; // 通过索引获取元组的值
    // 可以通过 数组.iter() 方式进行数组的迭代
    arr_name1.iter();
    ```

## 二 流程控制
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
- 关键字 match 能够对枚举类、整数、浮点数、字符、字符串切片引用（&str）类型的数据进行分支选择，类似于Java的switch。
- match分支选择中，必须包含所有的可能性。
- if let 语法， 是只区分两种情况的 match 语句的"语法糖"，避免了match需要匹配所有可能性的操作。

```rust
fn main() {
    // 例子一 match
    let var_str_1 = "abc";
    let var_str_2 = match var_str_1 {
        "abc" => {println!("Yes"); 1},
        "def" => {println!("Yes"); 2},
        _ => { println!("No"); 3}, // 通过使用下划线 _ 来匹配所有的可能性。类似于 default
    };

    // 例子二 if let
    let var_str_1 = "abc";
    match var_str_1 {
        "abc" => println!("Yes"),
        _ => { println!("No") }, // 通过使用下划线 _ 来匹配所有的可能性。类似于 default
    }
    if let "abc" = var_str_1 {
        println!("Yes");
    }else{
        println!("No")
    }

    // 例子三 if let
    let var_name = Some(9);   
    if let Some(temp) = var_name {  // 如果 var_name为非None，则会把9被赋值给temp变量，执行块内的代码
        println!("{}", temp);  
    }
    if let Some(9) = var_name { // 如果 var_name 等于 Some(9)，则执行块内的代码
        println!("{}", 9);  
    }
    if let Some(3) = var_name {
        println!("{}", 3);  
    }
}
```

### 循环
1. loop
2. while
3. for

```rust
// loop 无限循环
// loop 无限循环体内，可以通过 break 关键字结束循环，然后返回一个值
// loop 无限循环体内，可以通过 continue 关键字结束这一次迭代，从头开始继续循环。 
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
// 通过标签的方式跳出指定的loop循环
fn main() {
    let mut count = 0;
    'counting_up: loop { // 给这个loop循环添加一个标签
        println!("count = {}", count);
        let mut remaining = 10;

        loop {
            println!("remaining = {}", remaining);
            if remaining == 9 {
                break;
            }
            if count == 2 {
                break 'counting_up; // // 根据loop标签跳出指定的loop循环
            }
            remaining -= 1;
        }

        count += 1;
    }
    println!("End count = {}", count);
}
```

```rs
// while 循环
fn fun_while() {
    let mut var_number = 1;
    while var_number != 4 {
        println!("{}", var_number);
        var_number += 1;
    }
    println!("EXIT");
}
```

```rs
// 没有 for 的三元语句控制循环，例如 for (i = 0; i < 10; i++)

// for 循环遍历数组
fn fun_for() {
    let array = [10, 20, 30, 40, 50];

    for value in array {
        println!("array = {}", value);
    }
    for value in array.iter() {
        println!("array.iter = {}", value);
    }
    for i in 0..5 {
        println!("array[{}] = {}", i, array[i]);
    }
}
```

## 三 函数
- 函数是由一系列以表达式(Expression)结尾的声明(Statement)组成.
  - 声明是执行某种动作的指令，不返回值。
  - 表达式最后返回一个值。

- Rust是一门以表达式为基础的语言。

```rust
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

// 等同于上一个函数。任何函数都会默认返回()
fn main() -> (){
    function_name(1,2);
    return ();
}
```

## 四 所有权&引用
### 概述
- 堆数据引发了内存管理需求。
    - 如果我们需要储存的数据长度不确定（比如用户输入的一串字符串），我们就无法在定义时明确数据长度，也就无法在编译阶段让程序分配固定长度的内存空间供数据储存使用。因此编程语言会提供一种在程序运行时程序自己申请使用内存的机制，堆。

- 其它计算机语言的内存管理。
    - 在C语言机制中，可以调用``free(变量名)``，来释放内存。
    - 在java语言机制中，通过运行时垃圾回收机制释放，对性能产生一定的影响。

- Rust内存管理。
    - Rust所有权机制制定了一系列规范来进行内存管理。（所有权&引用）
    - **在编译阶段，编译器将会检查代码是否符合所有权机制规范。**
    - **在编译阶段，编译器检查到变量作用域结束时，将自动添加调用释放资源函数的步骤。**

- 基于以下三条规则形成Rust所有权机制。
    - 每个值都有一个变量，称为其所有者。
    - 一次只能有一个所有者。
    - 当所有者不在作用域内时，该值将被删除。

### 变量作用域
```rust
{
    // 在声明以前，变量 var_name 无效
    let var_name = "garysdevil";
    // 这里是变量 var_name 的作用域
}
// 变量作用域结束，变量 var_name 被释放
```

### 所有权转移 move
- 当堆变量被直接使用时，所有权都会发生转移。
- 堆数据所有者转移机制，**可以避免垂悬指针问题**。

1. 堆变量间的相互赋值，堆数据的所有权发生了转移（move），堆变量变为无效。
    ```rust
    // 基本数据类型都存储在栈中，变量值被复制给var_name2，不会导致数据所有权的移动。
    let var_name1 = 5;
    let var_name2 = var_name1;

    // 非基本数据类型的数据，存储在堆中。var_stack_name2指向var_stack_name1的数据值，var_stack_name1被释放。
    let var_stack_name1 = String::from("hello");
    let var_stack_name2 = var_stack_name1; // var_stack_name1 将被内存释放
    println!("{}, world!", var_stack_name1); // 错误！var_stack_name1 已经失效
    ```

2. 函数传递的输入参数/输出参数存储在堆里时，堆数据的所有权发生了转移（move），堆变量变为无效。
    ```rust
    fn main() {
        let var_stack_name1 = String::from("hello");
        // var_stack_name1 是非基本数据类型，存储在堆里，作为参数传入函数时，堆数据所有权发生了移动， var_stack_name1 变量变为无效。。
        func_name1(var_stack_name1);

        // var_name1 是基本数据类型，存储在栈里，作为参数传入函数时，var_name1 数据被复制了一份传入， var_name1 变量依然有效。
        let var_name1 = 5;
        func_name2(var_name1);
    }

    fn func_name1(some_string: String) {
        // 一个 String 参数 some_string 传入，变量有效
        println!("{}", some_string);
    } // 函数结束, some_string 在这里被释放

    fn func_name2(some_integer: i32) -> i32 {
        // 一个 i32 参数 some_integer 传入，变量有效
        println!("{}", some_integer);
    } // 函数结束, some_string 在这里被释放
    ```

### 堆数据的克隆
```rust
// 通过数据克隆，堆数据所有权不会被变更。
let var_stack_name1 = String::from("hello");
let var_stack_name2 = var_stack_name1.clone();

// let var_name2 = var_stack_name1; 如果直接通过这种方式赋值，将导致堆数所有权的移动，var_stack_name1将被释放，下面的语句将会报错。
println!("var_stack_name1 = {}, s2 = {}", var_stack_name1, var_stack_name2);
```

### 堆数据的引用
- 引用符号：&
- 如果A引用了B，则A的地址会指向B的地址。
- 引用、借用、租借 是相同的概念。
- 引用的所有权
    - 引用不会获取值的所有权。
    - 引用只是租借值的所有权。

- 引用注意点
    - 引用指向的地址背后的堆数据禁止为空。（**避免空指针问题**）
    - 引用必须在变量的生命周期内。（**避免垂悬指针问题**）（之后的章节会讲解变量的生命周期）

- 可变引用注意点
    - 可变引用不允许多重引用。意味着当可变引用未被释放时，所有者不能更改值或者对值进行其它操作。
    - 当变量的引用不再被后面的操作使用时，可以进行可变饮用。

- 通过禁止可变引用的多重引用，解决了数据竞争问题。
    - 以下三种行为会发生数据竞争
        - 两个或多个指针在同一时间访问相同的数据。
        - 至少有一个指针用于写入数据。
        - 没有用于同步数据访问的机制。

```rs
fn func_immutable_reference(){
    let var_stack_name1 = String::from("adam");
    let var_stack_name2 = &var_stack_name1; // var_stack_name2 租借 var_stack_name1 的所有权
    println!("var_stack_name1 is {}, var_stack_name2 is {}", var_stack_name1, var_stack_name2);
    let var_stack_name3 = var_stack_name1; // var_stack_name1 发生所有权移动，之前var_stack_name1的相关引用失效。
    let var_stack_name2 = &var_stack_name3; // var_stack_name2 租借 var_stack_name3 的所有权
}
```
```rs
fn func_mutable_reference(){
    let mut var_stack_name1 = String::from("AA-");
    let mut var_stack_name2 = &mut var_stack_name1; // var_stack_name2 是可变的引用

    var_stack_name2.push_str("BB-");
    println!("var_stack_name2 is {}", var_stack_name2);
    // 当 var_stack_name2 在函数内不在被使用，则 租借所有权结束
    
    let mut var_stack_name3 = &mut var_stack_name1;
    println!("var_stack_name3 is {}", var_stack_name3);
}
```
### 切片
- 切片（Slice）是对集合中的连续元素序列的部分引用。
- 切片是一种不可变引用，不拥有所有权。
- 字符串切片 = 字符串字面量 = &str

```rust
fn main() {
    // 声明一个 &str 类型的数据
    let var_slice_name = "hello";
    // 将字符串字面量转换为字符串对象
    var_slice_name.to_string();

    // 操作切片
    let mut var_string_name = String::from("garyadam");
    let var_slice_name1 = &var_string_name[0..4];
    let var_slice_name2  = &var_string_name[4..8];
    println!("{}={}+{}", var_string_name, var_slice_name1, var_slice_name2);

    // 操作切片
    let string_name = String::from("hello");
    // 下面两种方式得到的结果相同
    let slice1 = &string_name[0..2];
    let slice1 = &string_name[..2];
    // 下面两种方式得到的结果相同
    let slice2 = &string_name[3..string_name.len()];
    let slice2 = &string_name[3..];
    // 下面两种方式得到的结果相同
    let slice3 = &s[0..len];
    let slice3 = &s[..];

}
```

## 五 结构体

### 结构体
1. 定义结构体关键字 struct
2. 元组结构体 tuple structs
3. 单元结构体 unit-like structs 

```rust
// 结构体
#[derive(Debug)] // 通过衍生宏给下一个数据类型实现Debug特征，然后可以使用{:?}或{:#?}格式化结构体进行输出展示
struct Person { // 定义结构体
    name: String,
    nickname: String,
    age: u32
}
fn func_strcut() {
    // 创建结构体实例
    let gary = Person {
        name: dbg!(String::from("gary")), // 将结果返回并且输出信息到标准错误输出，这样可以在运行时看到这个变量的值
        nickname: String::from("garysdevil"),
        age: 18
    };
    // 创建结构体实例，更改个别属性值，其它属性值从另一个结构体实例里复制过来
    let newgary = Person {
        age: 19,
        ..gary // 进行复制操作
    };
    println!("gary is {}", gary.age);
    println!("newgary is {:?}", newgary); // :? 格式化输出一整个结构体实例
    println!("{:#?}", newgary); // :#？ 自动缩进格式化输出一整个结构体实例
}
```

```rs
// 元组结构体
fn func_tuple_strcut() {
    struct Color(u8, u8, u8); // 定义元组结构体
    let struct_black = Color(0, 0, 0); // 实例化元组结构体
    println!("black = ({}, {}, {})", struct_black.0, struct_black.1, struct_black.2);
}
```

```rs
// 单元结构体 // 当需要在某个类型上实现特征，但没有任何要存储在类型本身中的数据时，类单元结构可能很有用。（下面的章节会讲解特征）
struct AlwaysEqual; // 定义单元结构体

fn func_uint_strcut() {
    let subject = AlwaysEqual; // 实例化单元结构体
}
```
### impl块/函数/方法

- 关键字 impl 定义一个块，在 impl 块内， self 代表调用者， Self 代表调用者的类型。

- function 函数。

- methods 方法被定义在一个结构体、枚举、特征对象的内部，并且方法的第一个参数一定是self。

- 每个结构体可以有多个impl块。

### 结构体方法
```rust
struct Rectangle {
    width: u32,
    height: u32,
}

// 定义结构体方法时，struct关键字定义的结构体名字 和 impl关键字定义的块名字必须相同
// 注意： 结构体方法的第一个参数必须是 self，代表调用者
// 调用： 结构体方法需要结构体实例来调用。
impl Rectangle {
    fn area(&self) -> u32 { // 等价于  fn area(self: &Self) -> u32 {
        self.width * self.height // 等价于 (*self).width * self.height // Rust编译器自动添加 &, &mut, 或 *，因此不需要自己添加
    }
    fn wider(&self, rect: &Rectangle) -> bool { // 可以传递多个参数
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
// 注意： 结构体关联函数的返回数据必须是结构体。String::from() 就是一个结构体关联函数。
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

## 六 枚举
- 枚举
    - 可以列出所有可能的变量。枚举值只能是枚举类型中的一个变量。
    - 可以在枚举变量内部放置任何类型的数据。

- 在Rust世界里，Null 和 异常 都使用特殊的枚举类来处理。
### 枚举的定义 enum
```rs
// 当定义一条信息，内容可能是退出、移动、写入、改变颜色。
// 通过4个结构体来定义。看起来很凌乱，也不好实现共同的方法。
struct QuitMessage; // unit struct
struct MoveMessage {
    x: i32,
    y: i32,
}
struct WriteMessage(String); // tuple struct
struct ChangeColorMessage(i32, i32, i32); // tuple struct


// 通过枚举来进行定义。
#[derive(Debug)]
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}
impl Message { // 实现共同的方法
    fn call(&self) {
        // method body would be defined here
    }
}

fn main() {
    let m = Message::Write(String::from("hello"));
    println!("{:?}", m);
    m.call();
}
```

### 枚举与match
```rs
// 定义一个枚举类型
enum Book {
    Papery(u32), // 枚举类成员添加元组属性
    Electronic { url: String }, // 枚举类成员添加结构体属性；如果要为属性命名，则需要使用结构体语法
}

fn main() {
    let book2 = Book::Papery(1001); // 实例化枚举
    let book3 = Book::Electronic{url: String::from("garys.top")}; // 实例化枚举

    match book2 { // match 语句实现分支结构，类似于Java的switch
        Book::Papery( index ) => { // 如果枚举类成员拥有元组属性，则临时指定一个参数名字
            println!("Papery book {}", index);
        },
        Book::Electronic { url } => {
            println!("E-book {}", url);
        }
    }
}
```
```rs
fn main() {
    let dice_roll = 9;
    match dice_roll {
        3 => add_fancy_hat(),
        7 => remove_fancy_hat(),
        _ => (), // _ 下划线代表匹配任何值，() 代表不执行任何操作。
    }
}
fn add_fancy_hat() {}
fn remove_fancy_hat() {}
```

### None枚举 Option
- null是指由于某种原因当前无效或不存在的值。
- Option 是 Rust 标准库中的枚举类，这个枚举类用于填补 Rust 不支持 null 引用的空白，并且以一种安全的方式实现了被包装的null。
- Option 要么是一个Some中包含一个值，要么是一个None；对应Option::Some(value)和Option::None。

```rust
// Option枚举的基本形式
pub enum Option<T> {
    None,
    Some(T),
}
```

```rust
fn plus_one(x: Option<i32>) -> Option<i32> {
    match x {
        None => None,
        Some(i) => Some(i + 1),
    }
}

fn main() {
    // 例子一
    let five = Some(5);
    let six = plus_one(five);
    let none = plus_one(None);

    // 例子二
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
    // 通过 unwarp 方法获取 Some(x) 中 的 x 值。当值是None时则会报错。
    println!("{}", var_enum_name2.unwrap());
}
```

## 七 组织管理
### 包 package
- 当使用 `` cargo new ${project_name} `` 创建 Rust 工程时，工程目录下会建立一个 Cargo.toml 文件。
- 工程的实质就是一个包，包必须由一个 Cargo.toml 文件来管理，该文件描述了包的基本信息以及依赖项。

### 宝箱 crate
- crate 是二进制程序文件(a library crate)或者库文件( a binary crate)，存在于 package 中。

- crate root 是一个源文件，是 crate 的根， Rust 编译器以它为起始点，去寻找需要被编译的文件。每次编译时，编译器会去寻找二进制根和库根。
    - 二进制根 
        - src/main.rs 是一个 binary crate 的根；入口点 src/main.rs::main。
        - 通过将文件放在 src/bin 目录下，一个包可以拥有多个二进制 crate，每个 src/bin 下的文件都可以被编译成一个独立的二进制 crate。
    - 库根 
        - src/lib.rs 是一个 library crate 的根。

- package 可以包含多个 crate
    - 可以包含任意多个 binary crate。
    - 至多只能包含一个 library crate。
    - 至少包含一个 crate。

- 曾经需要使用 extern crate ${库名字} 来将外部库加载进作用域内，自从Rust 2018后，只需要向Cargo.toml添加外部依赖项，就会将外部库加载进整个crate作用域内。
    ```rs
    // 1.3 版本之前的语法
    #[macro_use] // 将 lib_name 宝箱内所有的宏作用域扩展到上一级
    extern crate lib_name;
    // 上面的代码放在根文件里，则表示将 lib_name 宝箱内所有的宏作用于全局，lib_name的宏可以直接在任何地方进行使用
    ```

### 模块 module
- 通过模块化可以进行作用域和私有变量的控制，工程组织结构的布局。

1. 权限
    - 对于 模块、函数、结构体、结构体属性、变量，不加 pub 修饰符，则默认是私有的。
    - 对于 枚举，只有在枚举类型前面添加 pub 修饰符，枚举变量即为公开的。
    - 对于私有的，只有在与其平级的路径或下级路径才能访问，不能从其外部访问。

2. 模块的声明
    1. 使用 `` mod 模块名{} `` 来声明一个私有模块， 使用 ``pub mod 模块名{} `` 来声明一个公有模块。
    2. 一个文件，本身就代表声明了一个模块，文件名为模块名，类似于``pub mod 文件名{} ``。
    3. 一个文件夹，需要在文件夹内创建 mod.rs 文件来表示声明为一个模块，类似于``pub mod 文件加名{} ``。对于文件夹内的子模块，需要在 mod.rs 内添加 `` pub mod 模块名; ``来对外暴露。

3. 模块的引入 
    1. 对于第三方的宝箱里的模块，可以通过在Cargo.toml配置文件内添加依赖，引入模块，让编译器识别。
    2. 对于工程里面的模块，需要在在crate的根文件内进行配置，引入模块，让编译器识别，配置方式如下：
        -  `` mod 模块名; ``
        -  `` crate::模块名::模块名; ``
        -  `` super::模块名::模块名 ``

4. 模块的调用
    - 方式一 `` 模块名::子模块名::方法名() ``。
    - 方式二 使用 use 关键字将某个模块的子模块导入到当前的模块作用域内，再进行调用 `` use 模块名::子模块名;  子模块名::方法名() ``。
    - 方式三 使用 use 关键字将某个模块下的函数都导入到当前的模块作用域内，再直接通过函数名进行调用 `` use 模块名::子模块名::*;  方法名() ``。

- 内置的标准模块（标准库） https://doc.rust-lang.org/stable/std/all.html

```rust
// vi phone_module.rs
pub fn message() -> String {
    String::from("执行发送信息的功能")
}
```
```rust
mod phone_module; // 导入模块

mod person_module {
    pub mod mouth {
        pub fn eat() { println!("执行吃的功能") }
    }
    // hand模块没有pub修饰符，只能被平级或者下级的路径访问
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

    use crate::person_module::mouth::eat; // 把 eat 模块导入当前的作用域内，然后可以直接使用
    use crate::person_module::mouth::eat as person_eat; // 把 eat 模块导入当前的作用域内，并且添加一个别名
    eat();
    person_eat();

    println!("{}", phone_module::message()); 

    // 引用标准库 std下的PI
    use std::f64::consts::PI;
    println!("{}", (PI / 2.0).sin());
}
```

## 八 集合
- Rust语言内置的数据结构被称之为集合(Collection)，数据被存储在堆中。

### 向量
- 向量（Vector）是一个可以动态存放多个值的数据结构，该结构将相同类型的值线性的存放在内存中。
- 向量的数据逻辑结构是数组，元素在内存中是相邻的。具有访问快，插入慢的特点。
- 在 Rust 中的表示是 Vec<T>。 <T>代表范型，在之后的章节中会讲解到。

```rust
    // 向量的声明
    let mut var_vector_1: Vec<i32> = Vec::new(); // 声明类型为 i32 的空向量
    let mut var_vector_2 = vec![1, 2, 4, 8];     // 通过宏创建向量

    // 向量添加一个元素
    var_vector_1.push(16);
    println!("{:?}", var_vector_1);

    var_vector_1.append(&mut var_vector_2); // 将一个向量移动到另一个向量的尾部
    println!("{:?}", var_vector_1);

    // 向量的遍历
    for ele in &var_vector_1 {
        println!("{}", ele);
    }

    // 获取向量元素 方式一 通过索引，返回值，可能会触发panic
    let does_not_exist = &var_vector_1[100];
    // 获取向量元素 方式一 通过get方法和索，返回Option<T>，不会触发panic
    match var_vector_1.get(100) {
        Some(third) => println!("The third element is {}", third),
        None => println!("There is no third element."),
    }

    // 通过存储相同的枚举类型来存储不同的变量类型。枚举变量是确定的类型，Rust编译器可以确定每个元素在堆内存里的空间分配。
    enum SpreadsheetCell {
        Int(i32),
        Float(f64),
        Text(String),
    }
    let row = vec![
        SpreadsheetCell::Int(3),
        SpreadsheetCell::Text(String::from("blue")),
        SpreadsheetCell::Float(10.12),
    ];
```

### 字符串
- 字符串(String) 是 UTF-8 编码的。
- 在Rust机制里，字符串是一种更为复杂的数据结构，是对Vec<u8>数据类型的包装。

```rust
fn main(){
    let mut var_string = String::new(); // 声明一个字符串
    var_string.push_str("oob"); // 追加字符串切片
    var_string.push('!');       // 追加字符

    // 其它数据类型转为字符串
    let one = 1.to_string();         // 整数转字符串
    let float = 1.3.to_string();     // 浮点转数字符串
    let slice = "slice".to_string(); // 字符串切片转字符串 

    // 字符串拼接
    let s1 = String::from("AA");
    let s2 = String::from("BB");
    let s3 = String::from("CC");
    let s4 = String::from("--") + &s1 + &s2 + &s3; // 字符串拼接方式一
    println!("{}", s4);
    let s5 = format!("{}-{}-{}", s1, s2, s3); // 字符串拼接方式二 格式化拼接，并且不会移动字符串的所有权
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
    println!("{}", var_chars.count()); // 字符集合统计字符的数量；变量所有权会被移动

    // 将字符串转为字符集，然后迭代
    for c in "नमस्ते".chars() {
        println!("{}", c);
    }
    //  将字符串转为字节，然后迭代
    for b in "नमस्ते".bytes() {
        println!("{}", b);
    }
}
```

### 映射表
- HashMap 映射表 哈希表
- HashMap实例的key或value必须是相同类型的。
```rust
use std::collections::HashMap;

fn main() {
    // HashMap的声明
    let mut map = HashMap::new();
    // 插入操作
    map.insert("color", "red"); 
    map.insert("size", "10 m^2");
    map.entry("color").or_insert("red"); //  确定键值值不存在则执行插入操作，并且返回插入值的可变引用

    map.insert("height", "170");
    //  键值存在则执行插入操作
    if let Some(x) = map.get_mut("height") {
        *x = "180";
    }
    println!("{}", map.get("height").unwrap());

    // 遍历
    for (key, value) in &map {
        println!("{}: {}", key, value);
    }

    // 统计字符串切片里的各个单词数量
    let text = "hello world wonderful world";
    let mut map = HashMap::new();
    for word in text.split_whitespace() {
        let count = map.entry(word).or_insert(0);
        *count += 1;
    }
    println!("{:?}", map);
}
```
## 九 错误处理
### 可恢复错误
```toml
[profile.release]
panic = 'abort' # 设置程序panic时直接终止程序，不进行回退和清理操作。 # 默认是panic时进行回退清理操作。
```

```rs
fn main() {
    // 手动进行panic操作
    panic!("crash and burn");
}
```

```bash
# 只有开启debug模式才能回溯(backtraces)信息，当使用``cargo build``或者``cargo run``时，没有 --release 时，debug模式是默认开启的。
RUST_BACKTRACE=1 cargo run
```

### 可恢复错误处理 枚举Result
- 在 Rust 中通过 Result<T, E> 枚举类作返回值来进行异常处理。
- 在 Rust 标准库中可能产生异常的函数的返回值都是 Result 枚举类型的，最常见的使用是在IO操作中。

```rs
// Result<T, E>
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

```rs
// 可恢复错误处理
use std::fs::File;
use std::io::ErrorKind;

fn main() {
    let f1 = File::open("./hello.txt");
    let f2 = File::open("./hello.txt");
    // 方式一
    if let Ok(file) = f1 {
        println!("File opened successfully.");
    } else {
        println!("Failed to open the file.");
    }
    // 方式二
    let f2 = match f2 {
        Ok(file) => file,
        Err(error) => match error.kind() {
            ErrorKind::NotFound => match File::create("hello.txt") {
                Ok(fc) => fc,
                Err(e) => panic!("Problem creating the file: {:?}", e), // // 抛出异常，程序终止
            },
            other_error => {
                panic!("Problem opening the file: {:?}", other_error)
            }
        },
    };
    // 方式三
    let f3 = File::open("hello.txt").unwrap_or_else(|error| {
        if error.kind() == ErrorKind::NotFound {
            File::create("hello.txt").unwrap_or_else(|error| {
                panic!("Problem creating the file: {:?}", error);
            })
        } else {
            panic!("Problem opening the file: {:?}", error);
        }
    });

    // 可恢复错误按不可恢复错误处理，直接抛出异常程序终止
    File::open("hello.txt").unwrap(); // 方式一
    File::open("hello.txt").expect("Failed to open."); // 方式二
    assert!(File::open("hello.txt").is_ok()); // 方式三
}
```

```rs
// 可恢复错误的传递

// 判断一个数字是否大于0
fn func_judge(i: i32) -> Result<i32, bool> {
    if i >= 0 { Ok(i) }
    else { Err(false) }
}
fn func_propagating_1(i: i32) -> Result<i32, bool> {
    // 传递错误 方式一
    let result = func_judge(i);
    return match result {
        Ok(i) => Ok(i),
        Err(b) => Err(b)
    };
}
fn func_propagating_2(i: i32) -> Result<i32, bool> {
    // 传递错误 方式二 通过?
    // Rust 中可以在 Result 对象后添加 ? 操作符，对Result进行内的结果进行提取，Err则直接传递出去，否则继续执行之后的代码
    let result = func_judge(i)?;
    Ok(result) // 因为确定 result 不是 Err, result 在这里已经是 i32 类型
}

fn main() {
    let result = func_propagating_2(-3);
    if let Ok(v) = result {
        println!("Ok: g(10000) = {}", v);
    } else {
        println!("Err:{:?}", result);
    }
}
```

- 当数据返回类型是 `Result` 或 `Option` 时可以在表达式尾部使用`?`来返回Err<> 或 None。
 
```rs
fn last_char_of_first_line(text: &str) -> Option<char> {
    text.lines().next()?.chars().last()
}
```

```rs
// 任意传递错误
use std::error::Error;
use std::fs::File;

fn main() -> Result<(), Box<dyn Error>> {
    let f = File::open("hello.txt")?;

    Ok(())
}
// 看不懂可以暂时先忽视掉，属于高级语法
// dyn是特征对象类型的前缀。在这里，dyn表示任何实现了Error特征的类型。
// dyn会影响性能，因为它不是静态调度的，它不能在编译时期确定传入参数的数据类型，也就不能将dyn转成特定类型的代码。
```

## 十 泛型
- 泛型机制是编程语言用于表达类型抽象的机制，一般用于功能确定、数据类型待定的类，如链表、映射表等。
- Rust泛型可以用来定义函数、结构、枚举和方法。 关键符合<>。
- Rust泛型不会影响性能，在编译阶段，编译器会根据上下文将泛型转成特定类型的代码。

- 范型函数
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

## 十一 特征
- 特征（trait）是一系列接口和方法的集合，任何一个类型都可以去实现一个特征。

- 特征（trait）概念接近于 Java 中的接口（Interface），但两者不完全相同。
  - 特征与接口相同的地方在于它们都是一种行为规范，可以用于标识哪些类/结构体有哪些方法。
  - 特征里既可以定义接口（没有方法体的方法），也可以定义方法。

- 可以定义特征实现了另一个特征。模版： `` trait 特征名称: 另一个特征名称 ``

- 注意： 特征和结构体，必须有其中一个是本地代码定义的。否则两个宝箱可以为同一个类型实现同一个特征，编译器将不知道哪个实现需要被使用到。

```rust
// 定义特征
trait MyTrait1 {
    // 这个方法可以被重写
    fn describe(&self) -> String {
        String::from("[Object]")
    }
    // 这个接口必须重写
    fn say(&self);

    fn new_self(&self) -> Self; // self指代的是当前的实例对象，Self指代的是实例对象的类型。
}
#[derive(Debug)]
struct Person {
    name: String,
    age: u8
}
// 结构体Person重写特征定义的方法describe
impl MyTrait1 for Person {
    fn describe(&self) -> String {
        format!("{} {}", self.name, self.age)
    }
    fn say(&self) {
        println!("iloveyou");
    }
    fn new_self(&self) -> Self {
        return Person { name: self.name.clone(), age: self.age };
    }
}
// 特征可以作为函数的参数。
fn say(T: &(impl MyTrait1 + std::fmt::Display)) { // 可以传入任意的数据类型，但数据类型必须实现 了MyTrait1 特征和 std::fmt::Display 特征
    println!("Breaking news! {:?}", T.say());
}
pub fn main() {
    let adam = Person {
        name: String::from("Adam"),
        age: 24
    };
    adam.say();
    println!("{}", adam.describe());
    println!("{:?}", adam.new_self());
}
```

## 十二 范型&特征&结构体
- 可以定义函数传入的范型数据类型必须实现了指定的特征。
- 可以定义函数返回的数据类型可以是任意的但是必须实现了指定的特征。
- 定义结构体方法时，可以定义结构体必须实现了指定的特征

### 范型&特征
```rs
// 范型&特征

// 定义一个特征
trait Comparable: std::fmt::Display { // Comparable特征实现了std::fmt::Display特征
    fn compare(&self, object: &Self) -> i8;
}
// impl<T: Debug> Comparable for T {
//     // --snip--
// }
// f32的数据类型实现Comparable特征
impl Comparable for f32 {
    fn compare(&self, object: &f32) -> i8 {
        if &self > &object { 1 }
        else if &self == &object { 0 }
        else { -1 }
    }
}
// 定义一个方法；输入参数 为 范型数据类型，并且该范型数据类型必须实现了Comparable特征
fn max_1<T: Comparable>(array: &[T]) -> &T {
// fn max<T: Comparable + My_Trait>(array: &[T]) -> &T { // 可以使用+加号，规定传入的数据类型必须实现了 Comparable 和 My_Trait 特征
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
// 返回的数据类型可以是必须实现了某个特征的数据类型
fn max_2<T: Comparable + Clone>(array: &[T]) -> impl Comparable {
    let mut max_index = 0;
    let mut i = 1;
    while i < array.len() {
        if array[i].compare(&array[max_index]) > 0 {
            max_index = i;
        }
        i += 1;
    }
    array[max_index].clone()
}
fn main() {
    let arr = [1.0, 3.0, 5.0, 4.0, 2.0];
    println!("maximum of arr is {}", max_2(&arr));
}
```

### 范型&特征&结构体
```rs
// 范型&特征&结构体
use std::fmt::Display;
struct Pair<T> {
    x: T,
    y: T,
}
impl<T> Pair<T> {
    fn new(x: T, y: T) -> Self {
        Self { x, y }
    }
}
// 定义结构体方法时，定义结构体必须实现了指定的特征
impl<T: Display + PartialOrd> Pair<T> {
    fn cmp_display(&self) {
        if self.x >= self.y {
            println!("The largest member is x = {}", self.x);
        } else {
            println!("The largest member is y = {}", self.y);
        }
    }
}
pub fn main() {
    let point1 = Pair{x:1, y:2}; // 编译器自动推断参数类型
    let point2 = Pair::<i32>{x:1, y:2}; // 通过turbofish语法，指定参数类型
    let point3 = Pair::new(2, 3);
    point1.cmp_display();
    point2.cmp_display();
    point3.cmp_display();
}
```

### where 关键字
```rs
// 复杂的数据类型和特征的绑定关系可以使用 where 关键字简化
// 例如：T数据类型必须实现了Display和Clone特征，U数据类型必须实现了Clone和Debug特征
fn some_function<T: Display + Clone, U: Clone + Debug>(t: T, u: U) -> i32
// 另一种更易于阅读的表达方式
fn some_function<T, U>(t: T, u: U) -> i32
    where T: Display + Clone,
        U: Clone + Debug
```


## 十三 生命周期
1. 程序中每个变量都有一个固定的作用域，当超出变量的作用域以后，变量就会被销毁。
2. 生命周期就是引用类型变量的有效作用域。
3. 在大多数时候，我们无需手动的声明生命周期，因为编译器可以自动进行推导。当多种类型存在时或多个生命周期存在时，编译器往往要求用户手动标明生命周期。

4. 生命周期注释用单引号开头，跟着一个小写字母单词：
    - &i32        // 常规引用
    - &'a i32     // 含有生命周期注释的引用
    - &'a mut i32 // 可变型含有生命周期注释的引用
    - &'static str  // 表示静态生命周期，则该引用的存活时间和该运行程序一样长。

- **声明周期可以避免垂悬指针问题**

### 1 函数中的生命周期
- 函数中的生命周期
    1. rust 中的借用是指对一块内存空间的引用。rust 有一条借用规则是借用方的生命周期不能比出借方的生命周期还要长。
    2. 对于一个参数和返回值都包含引用的函数而言，该函数的参数是出借方，函数返回值所绑定到的那个变量就是借用方。
    3. 生命周期注释是描述引用生命周期的办法。对函数的参数和返回值都进行生命周期注释，是告知编译器借用方和出借方的生命周期一样。

- 生命周期语法用来将函数的多个引用参数和返回值的作用域关联到一起，一旦关联到一起后，Rust 就拥有充分的信息来确保用户的操作是内存安全的。即确保当输入参数的值所有权发生改变后，函数返回的引用变量不能在被使用，避免避免垂悬指针问题。

````rust
// fun_longer函数在在编译期间将报错，因为返回值引用可能会返回过期的引用，rust机制不允许任何可能的意外发生
// fn fun_longer(var_str_1: &str, var_str_2: &str) -> &str { // 返回更长的字符串切片
//     if var_str_2.len() > var_str_1.len() {
//         var_str_2
//     } else {
//         var_str_1
//     }
// }

// 进行生命周期注释
// 输入参数，引用类型，'a的具体生命周期是var_str_1的生命周期与var_str_2的生命周期重叠的部分。即'a的生命周期等于var_str_1和var_str_1的生命周期中的较小者。
// 返回值，引用类型，生命周期必须<='a的生命周期
fn fun_longer_life<'a>(var_str_1: &'a str, var_str_2: &'a str) -> &'a str { // 返回更长的字符串切片
    if var_str_2.len() > var_str_1.len() {
        var_str_2
    } else {
        var_str_1
    }
}

fn main() {
    let result;
    {
        let var_str_1 = "rust";
        let var_str_2 = "ecmascript";
        result = fun_longer_life(var_str_1, var_str_2);
    }
    println!("{} is longer", result);
}
````

### 2 结构体中的生命周期
```rs
// 该生命周期标注说明结构体 ImportantExcerpt 所引用的字符串 str 必须比该结构体活得更久。
struct ImportantExcerpt<'a> {
    part: &'a str,
}

fn main() {
    let novel = String::from("Call me Ishmael. Some years ago...");
    let first_sentence = novel.split('.').next().expect("Could not find a '.'");
    let i = ImportantExcerpt {
        part: first_sentence,
    };
}

```

### 3 自动标注生命周期规则
- 编译器使用三条消除规则来确定哪些场景不需要显式地去标注生命周期
    1. 每一个引用参数都会获得独自的生命周期。
    2. 若只有一个输入生命周期(函数参数中只有一个引用类型)，那么该生命周期会被赋给所有的输出生命周期。
    3. 若存在多个输入生命周期，且其中一个是 &self 或 &mut self，则 &self 的生命周期被赋给所有的输出生命周期。

### 4 方法的生命周期
```rs
struct ImportantExcerpt<'a> {
    part: &'a str,
}

impl<'a> ImportantExcerpt<'a> {
    // announce_and_return_part1方法 和 announce_and_return_part2方法是等价的，因为编译器给符合自动标注生命周期规则的代码，进行了自动标注生命周期。
    fn announce_and_return_part1(&self, announcement: &str) -> &str {
        println!("Attention please: {}", announcement);
        self.part
    }
    fn announce_and_return_part2<'b>(&'a self, announcement: &'b str) -> &'a str {
        println!("Attention please: {}", announcement);
        self.part
    }
}
// <'a: 'b, 'b> 表示'a的生命周期比'b的生命周期长
impl<'a: 'b, 'b> ImportantExcerpt<'a> {
    fn announce_and_return_part3(&'a self, announcement: &'b str) -> &'b str {
        println!("Attention please: {}", announcement);
        self.part
    }
}
impl<'a> ImportantExcerpt<'a> {
    fn announce_and_return_part4<'b>(&'a self, announcement: &'b str) -> &'b str
    where
        'a: 'b,
    {
        println!("Attention please: {}", announcement);
        self.part
    }
}
```

### 5 静态生命周期
```rust
// 符串字面面具有 'static 生命周期
fn fn_main(){
    // let mark_twain: &str = "Samuel Clemens";
    let mark_twain = "Samuel Clemens"; // 这声明和上面是等价的
    print_author(mark_twain);
}
```

### 6 泛型/特征/生命周期
```rust
// 同时使用了泛型、特征、生命周期机制
// T 范型
// 'a 生命周期
// T 数据类型必须实现了 Display特征
use std::fmt::Display;
fn longest_with_an_announcement<'a, T>(
    x: &'a str,
    y: &'a str,
    ann: T,
) -> &'a str
where
    T: Display,
{
    println!("Announcement! {}", ann);
    if x.len() > y.len() {
        x
    } else {
        y
    }
}
fn main() {
    let string1 = String::from("abcd");
    let string2 = "xyz";

    let result = longest_with_an_announcement(
        string1.as_str(),
        string2,
        "Today is someone's birthday!",
    );
    println!("The longest string is {}", result);
}
```

## 十四 自动化测试
- 每一个测试函数都会运行在一个新的线程上。
- 断言
    1. assert! 判断布尔值
    2. assert_eq! 判断数字是否等于
    3. assert_ne! 判断数字是否不等于
- 测试函数的三个位置
    1. 单元测试 unit tests，可以写在宝箱内的任何文件里。单元测试函数所在的文件也必须通过``mod``被根文件引入，否则编译器将不会发现这些测试函数。
    2. 集成测试 integration test，默认在src/tests文件夹下。集成测试是从库宝箱外部，对一些列功能进行测试。
    3. doc tests. 


```bash
# cargo test指令
cargo test -- --test-threads=1 # 设置自动化测试不并行运行，只在一个线程上运行

cargo test -- --show-output # 展示测试成功的函数执行结果

cargo test ${name} # 测试函数名称含有${name}的都会运行

cargo test -- --ignored # 只运行含有#[ignore]标识的测试函数

cargo test -- --include-ignored # 运行测试函数和含有#[ignore]标识的函数

cargo test -p ${crate} # 运行特定宝箱的测试函数
```

```rs
// 单元测试
pub fn sub_two(a: u32) -> u32 {
    a - 2
}
#[cfg(test)] // 通过#[cfg(test)]标识指明该模块在cargo build时不需要被编译。
mod tests {
    use super::*;

    #[test] // 通过#[test]标注此函数为测试函数，只有在执行cargo test时才会运行
    fn it_sub_two() {
        assert_eq!(8, sub_two(10));
    }
    #[test]
    #[ignore] // #[ignore]标识表示测试函数在运行时被排除
    fn it_sub_two_custom() {
        let result = sub_two(10);
        assert!(
            result==8,
            "sub_two function returned a wrong result `{}`",
            result
        );
    }
    #[test]
    #[should_panic] // 断言这个测试函数会触发panic
    // #[should_panic(expected = "---")] // 断言这个测试函数会触发panic，panic内容为 ---
    fn it_sub_two_should_panic() {
        sub_two(0);
    }
    // 在测试中使用Result<T, E>
    #[test]
    fn it_works() -> Result<(), String> {
        if 10 - 2 == 8 {
            Ok(())
        } else {
            Err(String::from("ten minus two does not equal eight"))
        }
    }
}

```
## 十五 闭包&迭代
### 闭包
- 定义： 闭包(Closure)是一种匿名函数，它可以赋值给变量也可以作为参数传递给其它函数，不同于函数的是，它允许捕获调用者作用域中的值。

- 闭包函数的作用
    1. 使用函数作为参数进行传递
    2. 使用函数作为函数返回值
    3. 将函数赋值给变量


```rs
// 闭包的声明
fn main() {
    fn  add_one_v1   (x: u32) -> u32 { x + 1 }  // 函数声明方式
    let add_one_v2 = |x: u32| -> u32 { x + 1 }; // 闭包函数
    let add_one_v3 = |x|             { x + 1 }; // 闭包函数可以省去类型声明。编译器会根据上下文推测出输入参数的类型。
    let add_one_v4 = |x|               x + 1  ; // 因为只有一个表达式，所以这个闭包函数可以去掉花括号。
    add_one_v3(3);
    add_one_v3(4);
}
```

```rs
// 闭包函数可以捕获调用者作用域中的值。
// 当闭包从调用者作用域中捕获一个值时，会分配内存去存储这些值。对于有些场景来说，这种额外的内存分配会成为一种负担。与之相比，函数就不会去捕获这些环境值，因此定义和使用函数不会拥有这种内存负担。
fn main() {
   let x = 1;
   let sum = |y| x + y;
    assert_eq!(3, sum(2));

    // 通过 move 关键字，变量所有权被转移进闭包内。此功能通常用于闭包的生命周期大于所捕获的变量的原生命周期。
    let string_name = String::from("Iamcaptured");
    let closure_move_own = move || string_name; 
    assert_eq!("Iamcaptured", closure_move_own());
}
```

```rs
// 闭包作为参数
fn main() {
    time_spend(|| -> () {
        println!("--");
    });
}
fn time_spend(f: fn()) {
    let start = std::time::Instant::now();
    f();
    let duration = start.elapsed();
    println!("Total time elapsed  {:?}", duration);
}
```

```rs
// 结构体和闭包
// 如何实现泛型参数是闭包
fn main() {
struct Cacher<T>
    where
        T: Fn(u32) -> u32, // 泛型T受到了特征约束，Fn代表一个特征，使用闭包实现了特征。
    {
        query: T,
        value: Option<u32>,
    }
}
// 特征的闭包实现，有三种类型。任何闭包都实现了下面其中的一个特征
// Fn 该类型的闭包会对变量进行借用。
// FnMut 该类型的闭包会变量进行可变借用。
// FnOnce 该类型的闭包会转移变量的所有权。
```

### 迭代
- 迭代(Iterator)负责遍历序列中的每一项和决定序列何时结束的逻辑。
- Rust迭代器通过闭包函数实现了赖加载，是零成本抽象（zero-cost abstractions）之一，它意味着抽象并不会引入运行时开销。

- 标准库里Iterator特征实现的关联方法
    - iter() 
    - into_iter()
    - filter()
    - skip()
    - map()

```rs
// 所有的具有迭代功能的类型都实现了这个特征
pub trait Iterator {
    type Item;

    fn next(&mut self) -> Option<Self::Item>;

    // methods with default implementations elided
}
```

```rs
// 迭代示范
fn main() {
    let v1 = vec![1, 2, 3];

    // let v1 = vec![1, 2, 3];
    let v1_iter = v1.iter();
    for val in v1_iter { // v1_iter的所有权被拿走了
        println!("Got: {}", val);
    }

    let mut v1_iter = v1.iter();
    assert_eq!(v1_iter.next(), Some(&1)); // v1_iter的所有权还在， v1_iter被借用了并且被修改了，因此v1_iter必须是可变的变量
    assert_eq!(v1_iter.next(), Some(&2));
    assert_eq!(v1_iter.next(), Some(&3));
    assert_eq!(v1_iter.next(), None);


    let v2_iter = v1.iter().map(|x| x + 1); // 所有的数字加一，返回迭代器
    let v2: Vec<_>= v2_iter.collect(); // 获取所有迭代器的值生成新的集合
    assert_eq!(v2, vec![2, 3, 4]);
}

```

```rs
// 迭代+过滤操作示范
struct Shoe {
    size: u32,
    style: String,
}

fn shoes_in_size(shoes: Vec<Shoe>, shoe_size: u32) -> Vec<Shoe> {
    shoes.into_iter().filter(|s| s.size == shoe_size).collect()
}
```

```rs
// 自定义结构体实现迭代器特征
// 使用标准库中定义好的Iterator特征所实现的一些关于迭代器的关联方法
struct Counter {
    count: u32,
}
impl Counter {
    fn new() -> Counter {
        Counter { count: 0 }
    }
}
impl Iterator for Counter { // 实现迭代器特征
    type Item = u32;

    fn next(&mut self) -> Option<Self::Item> { // 实现迭代器接口
        if self.count < 5 {
            self.count += 1;
            Some(self.count)
        } else {
            None
        }
    }
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn calling_next_directly() {
        let mut counter = Counter::new();

        assert_eq!(counter.next(), Some(1));
        assert_eq!(counter.next(), Some(2));
        assert_eq!(counter.next(), Some(3));
        assert_eq!(counter.next(), Some(4));
        assert_eq!(counter.next(), Some(5));
        assert_eq!(counter.next(), None);
    }

    #[test]
    fn using_other_iterator_trait_methods() {
        let sum: u32 = Counter::new()
            .zip(Counter::new().skip(1)) // zip函数将两个迭代器合成一个迭代器对
            .map(|(a, b)| a * b) 
            .filter(|x| x % 3 == 0)
            .sum();
        assert_eq!(18, sum);
    }
}
```

## Rust不同于其它语言
- rust编程语言里 不支持 ++ 和 -- 的数学运算符号。

- rust编程语言里 没有 for 的三元语句控制循环，例如 for (i = 0; i < 10; i++)

- () 是一种特殊的类型，值只有一个就是() 
    - https://doc.rust-lang.org/std/primitive.unit.html