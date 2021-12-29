## 语法
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
// 如果在代码里未指定变量的数据类型，则编译时编译器会根据变量的值指定变量的数据类型。
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
1. 整数型
    ```rust
    // - 有符号8 bit整形 i8
    let var_name1: i8 = "aa";
    // - 无符号8 bit整形 u8
    let var_name1: u8 = "aa";
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

5. 复合类型
    - 一个变量可以包含不同类型的数据
    ```rust
    let tup_name: (i32, f64, u8) = (500, 6.4, 1);
    let (x, y, z) = tup;
    ```

6. 数组
    ```rust
    let arr_name1 = [1, 2, 3, 4, 5];
    let arr_name1: [i32; 5] = [1, 2, 3, 4, 5];
    ```

## 函数
```rust
// 如果要声明函数，必须使用 fn 关键字。
// 如果需要具备输入参数，必须声明参数名称和类型。
fn function_name1(x: i32, y: i32) {
    println!("x 的值为 : {}", x);
    println!("y 的值为 : {}", y);
}

// 如果需要返回数据，必须使用 -> 关键字，并且声明返回的数据类型
fn add(a: i32, b: i32) -> i32 {
    return a + b;
}
```

## 注意点
- 不支持 ++ 和 -- 的数学运算符号。