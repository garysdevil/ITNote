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

## 常识
1. 搜索时忽略大小写
    - :/${string}\c

2. 去掉整个文本的行尾空格
    - :%s/\s\+$//
3. 在行尾添加字符串
    - 方式一 :1,$ s/$/字符串/g  
    - 方式二 :%s/$/字符串/g