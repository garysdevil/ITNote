
## Cargo镜像源设置

```bash
vi $HOME/.cargo/config
```
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