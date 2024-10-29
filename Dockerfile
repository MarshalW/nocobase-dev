FROM node:23.1-bookworm

# DEB822 格式
RUN sed -i s@/deb.debian.org/@/mirrors.tuna.tsinghua.edu.cn/@g /etc/apt/sources.list.d/debian.sources

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install \
        iputils-ping \
        nano \
        curl \
        jq \
        -y

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install yarn -y

RUN yarn config set disable-self-update-check true
RUN yarn config set registry https://registry.npmmirror.com/
RUN yarn config set sqlite3_binary_host_mirror https://npmmirror.com/mirrors/sqlite3/

# git 全局设置
RUN git config --global user.email "marshal.wu@gmail.com"
RUN git config --global user.name "Marshal Wu"
RUN git config --global init.defaultBranch main

# 设置代理服务器
RUN echo "export PROXY_IP=localhost" >> ~/.bashrc
RUN echo "export PROXY_PORT=7890" >> ~/.bashrc
RUN echo 'alias proxy="export https_proxy=http://$PROXY_IP:$PROXY_PORT;export http_proxy=http://$PROXY_IP:$PROXY_PORT;export all_proxy=socks5://$PROXY_IP:$PROXY_PORT"' >> ~/.bashrc
RUN echo "alias unproxy='unset all_proxy;unset http_proxy;unset https_proxy;'" >> ~/.bashrc