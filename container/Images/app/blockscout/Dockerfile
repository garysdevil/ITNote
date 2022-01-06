FROM centos:7

WORKDIR /tmp

ENV LANG en_US.utf8
ENV SECRET_KEY_BASE PD6oNh2ag3dASlKh9aTu/xKSGP97i+yRHOD3BxBNHKFONQkG+GH+6E2M7M5hJEFs

# wget http://mirrors.aliyun.com/repo/epel-7.repo -P /etc/yum.repos.d/
RUN yum install -y epel-release \ 
    && yum upgrade -y --enablerepo=epel \
    && yum update -y --enablerepo=epel

RUN yum --enablerepo=epel install -y unzip \
    && yum --enablerepo=epel install -y wget \
    && yum --enablerepo=epel install -y ruby \
    && yum --enablerepo=epel install -y git

RUN yum --enablerepo=epel install -y libtool \
    && yum --enablerepo=epel install -y gmp-devel \
    && yum --enablerepo=epel group install -y "Development Tools" \
    && yum --enablerepo=epel install -y gmp-devel

# nodejs14 # 安装成功后进行验证 # node -v
RUN wget https://rpm.nodesource.com/setup_14.x \
    && bash setup_14.x \
    && yum install -y nodejs-14*

# rust # 安装成功后进行验证 rustc --version
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup.sh \
    && sh rustup.sh -y \
    && source $HOME/.cargo/env

# erlang # 安装成功后进行验证 # erl -version
RUN wget https://packages.erlang-solutions.com/erlang-solutions-2.0-1.noarch.rpm \
    && rpm -Uvh erlang-solutions-2.0-1.noarch.rpm \
    && yum install -y erlang

# elixir # 安装成功后进行验证 elixir -v # Elixir 1.12.3
RUN wget https://github.com/elixir-lang/elixir/releases/download/v1.12.3/Precompiled.zip \
    && unzip Precompiled.zip -d /

# blockscout
RUN cd /opt/ && git clone https://github.com/poanetwork/blockscout

# 安装Mix依赖和编译应用程序
RUN cd /opt/blockscout \
    && mix local.hex --force \
    && mix do local.rebar --force \
    && mix do deps.get
RUN cd /opt/blockscout \
    && source $HOME/.cargo/env \
    && mix do deps.compile \
    && mix do compile

# 生成 secret_key_base # 需要手动确认 # secret_key_base 可以重复使用
# cd /opt/blockscout \
# mix deps.get 
# mix phx.gen.secret

# 安装Node.js依赖 # 进行打包操作,3C3RAM耗时15分钟左右
RUN cd /opt/blockscout/apps/block_scout_web/assets  \
    && npm install \
    && node_modules/webpack/bin/webpack.js --mode production

# 构建静态资产
RUN cd /opt/blockscout/apps/block_scout_web/ \
    && mix phx.digest

# 启用HTTPS
RUN cd /opt/blockscout/apps/block_scout_web/ \
    && mix phx.gen.cert blockscout blockscout.local

# 添加环境变量
ENV DATABASE_URL="postgresql://postgres:postgres@localhost:5432/blockscout"
ENV DB_HOST=localhost
ENV DB_PASSWORD=postgres
ENV DB_PORT=5432
ENV DB_USERNAME=postgres
ENV ETHEREUM_JSONRPC_VARIANT=geth
ENV ETHEREUM_JSONRPC_HTTP_URL="http://localhost:8545"
ENV ETHEREUM_JSONRPC_WS_URL="ws://localhost:8544"
ENV SUBNETWORK=PRIVATE
ENV PORT=4000

# 清理
RUN yum install which nc -y \
    && rm -rf /tmp/* \
    && history -c

EXPOSE 4000 4001

WORKDIR /opt/blockscout

# 删除、创建和迁移数据库
# /usr/bin/mix do ecto.drop, ecto.create, ecto.migrate

# 启动
CMD ["mix", "phx.server"]
# http://127.0.0.1:4000/
# https://127.0.0.1:4001/