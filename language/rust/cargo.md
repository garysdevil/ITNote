
## Cargo镜像源设置

```bash
vi $HOME/.cargo/config
```
```conf
[source.crates-io]
registry = "https://github.com/rust-lang/crates.io-index"
# 指定镜像源
replace-with = 'ustc' # 如：tuna、sjtu、ustc，或者 rustcc

# 注：以下源配置一个即可，无需全部

# 中国科学技术大学
[source.ustc]
registry = "https://mirrors.ustc.edu.cn/crates.io-index"
# 或者 registry = "git://mirrors.ustc.edu.cn/crates.io-index"

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


## Cargo.toml
- 官方文档 https://doc.rust-lang.org/cargo/reference/manifest.html

```conf
[package]
name = "greeting" # cargo new greeting操作后默认生成；构建后的二进制名称。
version = "0.1.0" # cargo new greeting操作后默认生成。
edition = "2021" # cargo new greeting操作后默认生成。 指定大版本，目前rust有3个大版本 2015、2018、2021

categories = [] # categories字段是此包所属类别的字符串数组。 # 所有的类别 https://crates.io/category_slugs
# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

[features] # 条件编译
default = ["feature1"] # 定义一个默认选项，默认满足这个条件。
feature1 = []
feature2 = []
ssl = ["openssl"] # 定义一个条件，满足这个条件则获取 openssl 依赖。
nativetls = ["native-tls"] # 定义一个条件，满足这个条件则获取 native-tls 依赖。

[dependencies] # cargo new greeting操作后默认生成；crate的库依赖。
futures-preview = "0.3.0-alpha.13" # 来自 crates.io 的crate
; some-crate = { version = "1.0", registry = "my-registry" } 来自特定的crate仓库
romio = { git = "https://github.com/withoutboats/romio", branch = "master" } # 来自github的crate
myutils = "../myutils" # 来自本地的crate
myutils = { path = "myutils", version = "0.1.0" } # 来自本地的crate

# 根据硬件和系统类型，下载特定的依赖
# 通过 rustc --print=cfg 查询本地机器的 cfg targets 信息
# 通过 rustc --print=cfg --target=x86_64-pc-windows-msvc 查询特定机器的 cfg targets 信息
[target.'cfg(unix)'.dependencies] 
openssl = "1.0.1"

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
# exclude = [""]

[lib] # 当使用 --lib 参数生成crate时，才可以使用这个配置
name = "library_name" # 生成库的名字

[profile.release]
opt-level = 3 # 发布模式的默认优化等级是3.（cargo build --release）

# opt-level 程序优化
# 0：不进行优化，并且激活#[cfg(debug_assertions)]属性。
# 1：允许基本优化。
# 2：允许常用的优化。
# 3：允许所有的优化。
# "s"：允许常用的优化，外加一些能缩小体积的优化。
# "z"：类似"s"，但更偏重于体积的优化(可能会降低性能)。

# lto 减小二进制体积
# 在程序编译后的链接阶段时所采取的优化行为，通常可以顺带减少编译出来的二进制文件的体积，但也会显著增加编译时间和占用的内存，且有时对程序性能并没有正面的影响，所以Cargo程序项目在建置时缺省并没有激活LTO。
# lto = false # 默认都是false。

# codegen-units 通过切分代码来加速编译速度，减少优化
# 指定编译器在编译一个crate的时候要能其切分成多少份来同时处理。默认值是16或256，若改成1，则不进行切分，以增加套用更多的优化的机会，提升程序性能，但可能会让编译时间上升。
# codegen-units 叫做代码生成单元，Rust 编译器会把crate 生成的 LLVMIR进行分割，默认分割为16个单元，每个单元就叫 codegen-units，如果分割的太多，就不利于 Rust编译器使用内联优化一些函数调用，分割单元越大，才越容易判断需要内联的地方。但是这也有可能增大编译文件大小，需要大小和性能间寻找平衡。


# panic = "abort"
# 当程序发生panic时直接退出，并且可以缩减编译文件的大小。

# strip  减小二进制体积, 编译好后进行操作  strip 二进制路径
# 不管是在Debug编译模式还是Release编译模式，编译好的二进制档都会带有调试信息。Unix-like环境下，通过Release编译模式编译出来的二进制档，可以再通过strip指令，将其中不必要的标头和调试信息移除。
```