FROM centos:7

echo 'export LANG=en_US.UTF-8' >> /etc/profile
echo 'export LANG=en_US.UTF-8' >> /etc/bashrc
echo 'source /etc/profile.d/blockscount.sh' >> /etc/bashrc
# locale 验证是否设置成功

# wget http://mirrors.aliyun.com/repo/epel-7.repo -P /etc/yum.repos.d/
# yum upgrade -y --enablerepo=epel
yum install -y epel-release
yum update -y --enablerepo=epel

# yum install which

yum --enablerepo=epel install -y unzip
yum --enablerepo=epel install -y wget
yum --enablerepo=epel install -y ruby
yum --enablerepo=epel install -y git

yum --enablerepo=epel install -y libtool
yum --enablerepo=epel install -y gmp-devel
yum --enablerepo=epel group install -y "Development Tools"
yum --enablerepo=epel install -y gmp-devel

# nodejs14
wget https://rpm.nodesource.com/setup_14.x | bash setup_14.x
yum install -y nodejs-14*
# node -v

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup.sh
sh rustup.sh -y
source $HOME/.cargo/env

# erlang
wget https://packages.erlang-solutions.com/erlang-solutions-2.0-1.noarch.rpm
rpm -Uvh erlang-solutions-2.0-1.noarch.rpm
yum install -y erlang
# erl -version

# wget https://packages.erlang-solutions.com/erlang/rpm/centos/7/x86_64/esl-erlang_21.0.5-1~centos~7_amd64.rpm
# yum install -y wxGTK-devel unixODBC-devel


# elixir
wget https://github.com/elixir-lang/elixir/releases/download/v1.12.3/Precompiled.zip
unzip Precompiled.zip
# elixir -v


# blockscout
cd /
git clone https://github.com/poanetwork/blockscout
cd blockscout

# 生成 secret_key_base # 需要手动确认
mix deps.get 
mix phx.gen.secret

# 安装Mix依赖和编译应用程序
mix do deps.get
mix do local.rebar --force
mix do deps.compile
mix do compile


# 安装Node.js依赖
cd /blockscout/apps/block_scout_web/assets
npm install
# 进行打包操作
node_modules/webpack/bin/webpack.js --mode production

# 构建静态资产
cd /blockscout/apps/block_scout_web/
mix phx.digest

# 启用HTTPS
cd /blockscout/apps/block_scout_web/
cd apps/block_scout_web/
mix phx.gen.cert blockscout blockscout.local

# 添加环境变量
echo 'export DATABASE_URL="postgresql://postgres:postgres@localhost:5432/blockscout"

export DB_HOST=localhost
export DB_PASSWORD=postgres
export DB_PORT=5432
export DB_USERNAME=postgres

export SECRET_KEY_BASE="PD6oNh2ag3dASlKh9aTu/xKSGP97i+yRHOD3BxBNHKFONQkG+GH+6E2M7M5hJEFs"

export ETHEREUM_JSONRPC_VARIANT=geth
export ETHEREUM_JSONRPC_HTTP_URL="http://localhost:8545"
export ETHEREUM_JSONRPC_WS_URL="ws://localhost:8545"

export SUBNETWORK= MAINNET

export PORT=4000
export COIN="Test Coin"' > /etc/profile.d/blockscount.sh

# 删除、创建和迁移数据库
mix do ecto.drop, ecto.create, ecto.migrate


# 启动
mix phx.server