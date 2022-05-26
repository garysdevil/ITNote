## Rust介绍
- 2006年，Mozilla研究院的 Graydon Hoare 开始设计创造自己的私人项目 Rust 语言。
- 2009年，Mozilla开始赞助这个项目，后来在Dave Herman, Brendan Eich以及很多其他人的贡献下逐步完善的。
- 2010年，Rust 首次公开，同年开始改写自托管编译器（基于 LLVM 后端）来替换原来用 OCaml 写的编译器，在 2011 年实现了自我编译 [1]
- 2015年，第一个稳定版本 Rust 1.0 首次发布。

- Rust 的编译器是在 MIT License 和 Apache License 2.0 双重协议声明下的免费开源软件。
- Rust 有完善的提案流程（RFC，Request For Comments），每一个人都可以提交提案，进行开发工作的核心团队细分为专项治理语言项目、社区运营、语言核心开发、工具开发、库开发等，来管理维护各个项目的各方面事项。

## 相关链接
- 官网  https://www.rust-lang.org/
- Rust安装教程 https://www.rust-lang.org/tools/install
- 在线编译器 https://play.rust-lang.org/

## 安装Rust工具包
```bash
# 下载安装rust工具包
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

- rustup
    - Rust 的工具管理器。

- cargo
    - Rust 内置的构建系统和包管理器。
    - 可以使用 cargo 指令进行 工程构建、编译、运行、打包、获取包等功能。


## 术语
- 宝箱(crate)
    - 可以是 a library crate。
    - 可以是 a binary crate。

- 包(package)
    - 包含任意多个 binary crate。
    - 至多只能包含一个 library crate。
    - 至少包含一个 crate。

- crate root 是一个源文件，Rust 编译器以它为起始点，并构成 crate 的根模块。
    - 二进制根 
        - src/main.rs 是一个 binary crate 的根；入口点 src/main.rs::main。
        - 通过将文件放在 src/bin 目录下，一个包可以拥有多个二进制 crate，每个 src/bin 下的文件都会被编译成一个独立的二进制 crate。
    - 库根 
        - src/lib.rs 是一个 library crate 的根。

- 模块(mod)
    - 模块的声明
        - 可以使用 ``` mod 模块名{} ``` 来声明一个模块。
        - 一个文件，其本身就代表声明了一个模块，文件名为模块名。
        - 一个文件夹，需要在文件夹内创建 mod.rs 文件来表示声明了一个模块。文件夹内的模块需要通过 mod.rs 文件进行对外暴露。
    - 编译器只能看到 crate root 的根文件，如果需要使用模块，则需要在根文件下使用mod关键字进行引用，例如 ``` mod 模块名; ```。
    - 当前模块需要使用其它的模块，也需要使用mod关键字进行引用，例如``` mod 模块名; ```。
    - 当模块被引入后，调用模块内函数的方式 
        - 方式一 ``` 模块名::模块名::方法名() ``` 
        - 方式二 使用use关键字将某个模块下的函数都引入到当前的模块下，再直接通过函数名进行调用 ``` use 模块名::模块名::*; 方法名() ```。

## 指令

```bash
# rustup 相关操作
rustup update # 升级rust
rustup self uninstall # 卸载rust相关的工具
rustup install nightly # 安装nightly版本
rustup toolchain list # 查看rust工具包版本
rustup override set nightly # 设置使用nightly版本

```

```bash
# rust 相关操作
rustc -V # 查看rust编译器版本
rustc ${filepath} # 编译生成二进制文件
```

```bash
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
