# HUGO
## 概念
1. Hugo是由Go语言实现的静态网站生成器。
2. 由 主题模板 和 markdown文章 编译生成静态网页。
3. 可以作为一个web服务器。

## 安装
1. windows环境下载解压即可使用
https://github.com/gohugoio/hugo/releases/download/v0.79.0/hugo_0.79.0_Windows-64bit.zip


## 使用
1. 创建一个工程
```bash
project=myblog
hugo new site ${project}
cd ${project}
```

2. 创建一篇博客
```bash
path=posts/my-first-post.md
hugo new ${path} # 生成一个模板文件
```

3. 主题安装
```bash 
git init
git submodule add https://github.com/budparr/gohugo-theme-ananke.git themes/ananke
```
或者
```bash
cd themes
git clone https://github.com/vjeantet/hugo-theme-casper.git casper
git clone https://gitee.com/tangjin520/hugo-casper3 casper # 穷苦潦倒的时候选择gitee
```

4. 配置文件 
config.toml  
```conf
# 制定主题是 casper
theme = "casper"
```

5. 编译预览
```bash
hugo server -D
# -D 编译预览
# -t 指定themes目录下的主题
```