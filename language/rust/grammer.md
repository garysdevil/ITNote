## 语法
- hello world
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