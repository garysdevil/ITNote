1、vim
# 安装pathogen插件管理
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

vim vimrc
# 在尾行添加
execute pathogen#infect()
syntax on
filetype plugin indent on


