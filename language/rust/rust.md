# Rust
- Rust 语言由 Mozilla 开发，最早发布于 2014 年 9 月。
- Rust 的编译器是在 MIT License 和 Apache License 2.0 双重协议声明下的免费开源软件。
- 在线编译器 https://play.rust-lang.org/
- 官网  https://www.rust-lang.org/


## 安装
- 参考 https://www.rust-lang.org/tools/install

- 指令
    - rustup
        - Rust 的工具管理器。
    - cargo
        - Rust 的构建系统和包管理器。
        - 可以使用 cargo 指令进行 工程构建、编译、运行、打包、获取包等功能。

```bash
# 下载安装rust以及相关工具
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env


# rustup 相关操作
rustup update # 升级rust
rustup self uninstall # 卸载rust相关的工具


# rust 相关操作
rustc -V # 查看rust编译器版本
rustc ${filepath} # 编译生成二进制文件


# cargo 相关操作
cargo new greeting # 构建一个项目
cargo build # 编译一个项目
# cargo build/run --release 使用 release 编译会比默认的 debug 编译性能提升 10 倍以上，但是 release 缺点是编译速度较慢，而且不会显示 panic backtrace 的具体行号 
cargo run # 编译运行一个项目
cargo install --path . # 安装二进制文件（默认位置 $HOME/.cargo/bin）

cargo clippy # 类似eslint，lint工具检查代码可以优化的地方
cargo fmt # 类似go fmt，代码格式化
cargo tree # 查看第三方库的版本和依赖关系
cargo bench # 运行benchmark(基准测试,性能测试)
cargo udeps # 检查项目中未使用的依赖 (第三方工具，需要单独下载)
```