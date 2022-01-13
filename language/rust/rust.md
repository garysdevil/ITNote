# Rust
- Rust 语言由 Mozilla 开发，最早发布于 2014 年 9 月。
- Rust 的编译器是在 MIT License 和 Apache License 2.0 双重协议声明下的免费开源软件。
- 在线编译器 https://play.rust-lang.org/
- 官网  https://www.rust-lang.org/


## 安装
- 参考 https://www.rust-lang.org/tools/install

```rust
# 下载安装rust以及相关工具
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

- 二进制工具
    - rustup
        - Rust 的工具管理器。
    - cargo
        - Rust 内置的构建系统和包管理器。
        - 可以使用 cargo 指令进行 工程构建、编译、运行、打包、获取包等功能。

### cargo镜像源设置
- 参考 https://cargo.budshome.com/reference/source-replacement.html

vi $HOME/.cargo/config
```conf
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
# 指定镜像
replace-with = '镜像源名' # 如：tuna、sjtu、ustc，或者 rustcc

# 注：以下源配置一个即可，无需全部

# 中国科学技术大学
[source.ustc]
registry = "https://mirrors.ustc.edu.cn/crates.io-index"
# >>> 或者 <<<
registry = "git://mirrors.ustc.edu.cn/crates.io-index"

# 上海交通大学
[source.sjtu]
registry = "https://mirrors.sjtug.sjtu.edu.cn/git/crates.io-index/"

# 清华大学
[source.tuna]
registry = "https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git"

# rustcc社区
[source.rustcc]
registry = "https://code.aliyun.com/rustcc/crates.io-index.git"

```
## 术语
- 宝箱(crate)
    - 一个库(a library crate)。
    - 一个二进制文件(a binary crate)。
- 包(package)
    - 包含任意多个二进制文件 crate(binary crate)。
    - 至多 只能 包含一个库 crate(library crate)。
    - 至少包含一个 crate，无论是库的还是二进制的。

- crate root 是一个源文件，Rust 编译器以它为起始点，并构成你的 crate 的根模块。
    - 二进制根 src/main.rs ，入口点 src/main.rs::main。
    - 一个库根 src/lib.rs ，共享代码。

- 每个 src/bin 下的文件都会被编译成一个独立的二进制 crate。

## 指令

```bash
# rustup 相关操作
rustup update # 升级rust
rustup self uninstall # 卸载rust相关的工具


# rust 相关操作
rustc -V # 查看rust编译器版本
rustc ${filepath} # 编译生成二进制文件


# cargo 相关操作
cargo --version
cargo new greeting # 构建一个项目 默认参数--bin
cargo build # 编译一个项目
# cargo build/run --release 使用 release 编译会比默认的 debug 编译性能提升 10 倍以上，但是 release 缺点是编译速度较慢，而且不会显示 panic backtrace 的具体行号 
cargo run # 编译运行一个项目
cargo install --path . # 安装二进制文件（默认位置 $HOME/.cargo/bin）

cargo clippy # 类似eslint，lint工具检查代码可以优化的地方
cargo fmt # 类似go fmt，代码格式化
cargo tree # 查看第三方库的版本和依赖关系
cargo udeps # 检查项目中未使用的依赖 (第三方工具，需要单独下载)

# 创建与运行基准测试
cargo new benches
cargo bench # 运行benchmark(基准测试,性能测试)

```

## Cargo.toml
- https://doc.rust-lang.org/cargo/reference/manifest.html

```conf
[package]
name = "greeting" # cargo new greeting操作后默认生成；构建后的二进制名称。
version = "0.1.0" # cargo new greeting操作后默认生成。
edition = "2021" # cargo new greeting操作后默认生成。

categories = [] # categories字段是此包所属类别的字符串数组。 # 所有的类别 https://crates.io/category_slugs
# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

[features] # 条件编译
default = ["feature1"] # 定义一个默认选项，默认满足这个条件。
feature1 = []
feature2 = []
ssl = ["openssl"] # 定义一个条件，满足这个条件则获取 openssl 依赖。
nativetls = ["native-tls"] # 定义一个条件，满足这个条件则获取 native-tls 依赖。

[dependencies] # cargo new greeting操作后默认生成；crate的库依赖。
aaa = "../aaa" # 来自本地的crate
futures-preview = "0.3.0-alpha.13" # 来自 crates.io 的crate
romio = { git = "https://github.com/withoutboats/romio", branch = "master" } # 来自github的crate
[dependencies.openssl] # 可选依赖，满足条件才拉取进行编译
optional = true
version = "0.10"
[dependencies.native-tls] # 可选依赖，满足条件才拉取进行编译
optional = true
version = "0.2"

[dev-dependencies] # 开发时的库依赖, 例如examples, tests, and benchmarks的库依赖。
[build-dependencies] # build scripts的库依赖。

[workspace] # 
members = [] # 相当于你自己可以在src中添加其它的二进制package，然后可以引用这些二进制package里的东西。

[lib] # 当使用 --lib 参数生成crate时，才可以使用这个配置
name = "library_name" # 生成库的名字
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

#[cfg(some_condition)]
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
