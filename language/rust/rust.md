---
created_date: 2021-12-21
---

[TOC]

## Rust介绍
- 2006年，Mozilla研究院的 Graydon Hoare 开始设计创造自己的私人项目 Rust 语言。
- 2009年，Mozilla开始赞助这个项目，后来在Dave Herman, Brendan Eich以及很多其他人的贡献下逐步完善的。
- 2010年，Rust 首次公开，同年开始改写自托管编译器（基于 LLVM 后端）来替换原来用 OCaml 写的编译器，在 2011 年实现了自我编译 [1]
- 2015年，第一个稳定版本 Rust 1.0 首次发布。

- Rust 的编译器是在 MIT License 和 Apache License 2.0 双重协议声明下的免费开源软件。
- Rust 有完善的提案流程（RFC，Request For Comments），每一个人都可以提交提案，进行开发工作的核心团队细分为专项治理语言package、社区运营、语言核心开发、工具开发、库开发等，来管理维护各个package的各方面事项。

## 相关链接
- 官网  https://www.rust-lang.org/
- 学习 https://doc.rust-lang.org/book/
- 学习 https://course.rs/about-book.html  https://github.com/sunface/rust-course  Rust语言圣经(中文)
- 学习 通过```rustup doc```获取离线学习文档
- Rust安装教程 https://www.rust-lang.org/tools/install
- 在线编译器 https://play.rust-lang.org/
- 宝箱文档 https://docs.rs/

## Rust工具包
- Rust工具链管理器 ``rustup``
```bash
# 下载安装Rust工具链管理器
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
rustc -V
```

- channel： Rust发布在三个不同的"channel"上：stable，beta 和 nightly，对应三种不同的版本。
### rustup 工具链
1. Rust编译器 ``rustc``

2. Rust标准库rust-std

3. Rust包管理和构建工具 ``cargo``
    - 可以使用 cargo 指令进行 工程构建、编译、运行、打包、获取包等功能。

4. Rust文档生成器 ``rustup doc``

5. Rust源代码格式化工具
    - ``cargo-fmt 或者 cargo fmt``
    - ``rustfmt``

6. Rust代码检查工具 ``cargo clippy``
    - 参考 https://magiclen.org/clippy/
    - lint最早用于C语言，是一种用来检查代码的工具，现在的主流编程语言几乎都有lint可以使用，尤其是JavaScript、Python等直译式编程语言，因为它们的代码不会经过编译，所以特别需要使用lint来检查原代码。
    - 通过lint，可以写出疑虑较少、性能更好或是更容易阅读的代码。
    - Rust编程语言虽然是静态类型的编程语言，而且拥有十分严谨的编译器，但官方还是提供了一个lint工具 Clippy。

### 其它
- 调试器 ``rust-gdb``

- 代码提示工具
    - rls
        - Rust 语言服务器（RLS）基于 LSP（Language Server Protocol），即语言服务器协议，LSP 由红帽、微软和 Codenvy 联合推出，可以让不同的程序编辑器与集成开发环境（IDE）方便地嵌入各种编程语言，允许开发人员在最喜爱的工具中使用各种语言来编写程序。
    - racer

## 指令

```bash
# rustup 相关操作
rustup update # 升级rust
rustup show # 展示目前所有安装的工具链
rustup self uninstall # 卸载rust相关的工具
rustup install nightly # 安装nightly版本
rustup install 1.57 # 安装历史版本1.57
rustup toolchain list # 查看rust工具包版本
rustup override set nightly # 设置使用nightly版本
cargo +nightly-2020-09-30 build --release # 指定rustup版本进行编译
```

```bash
# rustc 相关操作
rustc -V # 查看rust编译器版本
rustc ${filepath} # 编译生成二进制文件
```

```bash
# cargo 相关操作
cargo --version
cargo new greeting # 构建一个package 默认参数--bin
cargo init greeting # 在现有的一个package中，创建一个新的package 默认参数--bin
cargo build # 编译一个package，会激活#[cfg(debug_assertions)]属性，来使用调试(debug)相关的代码。
cargo build --release # 允许使用编译器所有的优化功能，并禁用有加上#[cfg(debug_assertions)]属性的代码
cargo install --path . # 安装二进制文件（默认位置 $HOME/.cargo/bin）
# cargo build/run --release 使用 release 编译会比默认的 debug 编译性能提升 10 倍以上，但是 release 缺点是编译速度较慢，而且不会显示 panic backtrace 的具体行号 
cargo run # 编译运行一个package
cargo check # 快速检查代码语法的正确性，并不会进行编译操作
cargo fix # 查看告警项，并且可能进行自动修复  --allow-dirty
cargo update # 会下载更新最新的依赖版本进Cargo.toml.lockd文件，输出相关的更新内容；但Cargo.toml的文件需要手动更新。
cargo clippy # 类似eslint，lint工具检查代码可以优化的地方
cargo fmt # 类似go fmt，代码格式化
cargo tree # 查看第三方库的版本和依赖关系
cargo udeps # 检查package中未使用的依赖 (第三方工具，需要单独下载)

# 子指令
cargo --list # 列出所有的子指令
# 如果二进制程序在$PATH目录下，并以 cargo-${name} 方式命名，则二进制都可以作为cargo的子指令，可以通过cargo ${name} 来运行

# 文档
cargo doc # 生成package文档
cargo doc --open  # 生成package文档并且在网页上打开

# 创建与运行基准测试
cargo new benches
cargo bench # 运行benchmark(基准测试,性能测试)
cargo bench --bench ${filename}  # 运行指定的文件
cargo bench -- --save-baseline ${name} # 显示当次结果，并且和名字为${name}的结果进行比较，然后将当次结果覆盖进${name}
cargo bench -- --baseline ${name} # 显示当次结果，并且和名字为${name}的结果进行比较
cargo bench -- --load-baseline ${name1}  --baseline ${name2} # --load-baseline ${name} 加载名字为${name1}的结果作为当次结果，将名字为{name2}的结果作为上次结果，然后进行比较

# 发布宝箱进入crates.io 
# 使用github账户登入crates.io ，获取token
cargo login ${token} # 登入crates.io，API token 将会被存入这个文件内 ~/.cargo/credentials 
cargo publish # 发布宝箱

# 虽然你不能删除之前版本的 crate，但是可以阻止任何将来的package将他们加入到依赖中。通 cargo yank 指令
cargo yank --vers 1.0.1 # 禁止用户在使用1.0.1这个版本的宝箱
cargo yank --vers 1.0.1 --undo # 撤回
```

## 编译器
- 编译过程
    1. 源代码（Rust Code）
    2. 通过分词变为词条流（Tokens）
    3. 通过解析变为抽象语法树（AST）
    4. 通过降级简化为高级中间语言HIR，生成*.hir文件（HIR）
    5. 编译器对高级中间语言HIR进行类型检查、方法查找等。（HIR）
    6. 通过降级简化为中级中间语言MIL（MIL）
    7. 编译器对中级中间语言MIL进行借用检查、优化、宏的代码生成、范型、单态化等。（MIL）
    8. 转译为LLVM的中间语言LLVMIR（LLVMIR）
    9. 通过LLVM后端，优化，生成机器码。


## Rust编程思想
- 逻辑代码
    - 把程序分成main.rs和lib.rs，主要代码逻辑放在lib.rs里。
    - main.rs主要负责调用命令行解析逻辑、设置配置项、调取lib.rs的运行函数、处理lib.rs运行函数返回的错误。

- Test-driven development (TDD) process

## Rust
- rustacian rust编程者