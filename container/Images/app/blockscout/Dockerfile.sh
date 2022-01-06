# 运行docker
# docker run -d --name centos1 centos:7 sleep  3153600000

# 设置 语言 # 通过运行 locale 指令验证是否设置成功
echo 'export LANG=en_US.UTF-8' >> /etc/profile
echo 'export LANG=en_US.UTF-8' >> /etc/bashrc

# 设置 SECRET_KEY_BASE
echo 'export SECRET_KEY_BASE="PD6oNh2ag3dASlKh9aTu/xKSGP97i+yRHOD3BxBNHKFONQkG+GH+6E2M7M5hJEFs"' >> /etc/profile
echo 'export SECRET_KEY_BASE="PD6oNh2ag3dASlKh9aTu/xKSGP97i+yRHOD3BxBNHKFONQkG+GH+6E2M7M5hJEFs"' >> /etc/bashrc

source /etc/profile
cd /tmp

# wget http://mirrors.aliyun.com/repo/epel-7.repo -P /etc/yum.repos.d/
yum install -y epel-release 
yum upgrade -y --enablerepo=epel
yum update -y --enablerepo=epel

yum --enablerepo=epel install -y unzip
yum --enablerepo=epel install -y wget
yum --enablerepo=epel install -y ruby
yum --enablerepo=epel install -y git

yum --enablerepo=epel install -y libtool
yum --enablerepo=epel install -y gmp-devel
yum --enablerepo=epel group install -y "Development Tools"
yum --enablerepo=epel install -y gmp-devel

# nodejs14 # 安装成功后进行验证 # node -v
wget https://rpm.nodesource.com/setup_14.x
bash setup_14.x
yum install -y nodejs-14*

# rust # 安装成功后进行验证 rustc --version
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup.sh
sh rustup.sh -y
source $HOME/.cargo/env

# erlang # 安装成功后进行验证 # erl -version
wget https://packages.erlang-solutions.com/erlang-solutions-2.0-1.noarch.rpm
rpm -Uvh erlang-solutions-2.0-1.noarch.rpm
yum install -y erlang

# elixir # 安装成功后进行验证 elixir -v # Elixir 1.12.3
wget https://github.com/elixir-lang/elixir/releases/download/v1.12.3/Precompiled.zip
unzip Precompiled.zip

# blockscout
cd /opt/ && git clone https://github.com/poanetwork/blockscout

# 安装Mix依赖和编译应用程序
cd /opt/blockscout
mix local.hex --force
mix do local.rebar --force
mix do deps.get
mix do deps.compile
mix do compile

# 生成 secret_key_base # 需要手动确认 # secret_key_base 可以重复使用
# cd /opt/blockscout
# mix deps.get 
# mix phx.gen.secret

# 安装Node.js依赖 # 进行打包操作
cd /opt/blockscout/apps/block_scout_web/assets 
npm install
node_modules/webpack/bin/webpack.js --mode production

# 构建静态资产
cd /opt/blockscout/apps/block_scout_web/
mix phx.digest

# 启用HTTPS
cd /opt/blockscout/apps/block_scout_web/
mix phx.gen.cert blockscout blockscout.local

# 添加环境变量
(echo 'export DATABASE_URL="postgresql://postgres:postgres@localhost:5432/blockscout"'
    echo 'export DB_HOST=localhost'
    echo 'export DB_PASSWORD=postgres'
    echo 'export DB_PORT=5432'
    echo 'export DB_USERNAME=postgres'
    echo 'export ETHEREUM_JSONRPC_VARIANT=geth'
    echo 'export ETHEREUM_JSONRPC_HTTP_URL="http://localhost:8545"'
    echo 'export ETHEREUM_JSONRPC_WS_URL="ws://localhost:8544"'
    echo 'export SUBNETWORK=PRIVATE'
    echo 'export PORT=4000'
    echo 'export COIN="TestCoin"') > /etc/profile.d/blockscount.sh

echo 'source /etc/profile.d/blockscount.sh' >> /etc/profile
echo 'source /etc/profile.d/blockscount.sh' >> /etc/bashrc
rm -rf /tmp/* \
history -c

# 删除、创建和迁移数据库
# cd /opt/blockscout && mix do ecto.drop, ecto.create, ecto.migrate

# 启动
# mix phx.server
# http://127.0.0.1:4000/
# https://127.0.0.1:4001/