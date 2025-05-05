---
created_date: 2020-11-16
---

[TOC]

## 安装pathogen插件管理
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

vim vimrc
```conf
# 在尾行添加
execute pathogen#infect()
syntax on
filetype plugin indent on
```

## 插件
### NERD tree
- NERD tree
    - 是一款vim树形文件资源管理器插件。
    - 可以在vim中浏览文件系统，打开想要的文件或目录。
- 源码 https://github.com/scrooloose/nerdtree
- 下载安装教程 https://www.vim.org/scripts/script.php?script_id=1658

- :NERDTree
    - 打开新的目录树。可以提供一个路径参数，那么命令将打开以该路径作为根目录的目录树。如果没有路径参数提供，那么当前目录将作为新的目录树的根目录。
- :NERDTreeToggle
    - 如果当前标签已经存在目录树，该命令会重新刷新目录树显示；如果当前标签不存在目录树，该命令作用效果与:NERDTree命令一致。
- :NERDTreeClose
    - 关闭当前标签的目录树。

- 设置快捷键 /etc/vim/vimrc 
```
" 绑定F2到NERDTreeToggle指令
map <F2> :NERDTreeToggle<CR>

" 绑定ctrl+n到NERDTreeToggle指令
map <C-z> :NERDTreeToggle<CR>
```

## 常识
1. 搜索时忽略大小写 `` :/${string}\c ``

2. 在每行行首添加相同的内容 `` :%s/^/要添加的内容/g `` 

3. 在每行行尾添加相同的内容 `` :%s/$/要添加的内容/g `` 或 `` :1,$ s/$/字符串/g ``

4. 去掉整个文本的行尾空格 `` :%s/\s\+$//g `` 
5. 去掉整个文本的行尾分号 `` :%s/\;\+$//g ```

### 文件的基本操作
- 在新窗口新建一个文件
    - :new
- 在新tab中新建文件
    - :tabnew
- 编辑指定文件(edit)，没有则新建
    - :e ${filepath}
- 打开一个文件
    - :open ${file}
- 水平分割vim窗格
    - :split  
    - 简写 :sp
- 垂直分割vim窗格
    - :vsplit
    - 简写 :vsp
- 在窗格间切换
    - Ctrl+ww 下个窗格
    - ctrl+w –>上下左右（先按ctrl+w，放开，再按方向键）  
- 下一个文件
    - :bn
    - :n
- 上一个文件
    - :bp
    - :N
- 显示文件缓存
    - :ls
- 移至该文档
    - :b 文档名或编号