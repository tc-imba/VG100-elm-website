FROM ubuntu:18.04

ENV HOME="/root"

# Install dependencies
COPY ./sources.list /etc/apt/
RUN apt-get update && \
    apt-get install -y python python3-pip curl git redis && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# Install node.js
ENV NVM_DIR="$HOME/.nvm"
RUN \. "$NVM_DIR/nvm.sh" && nvm install 12

# Copy the cb4 dependencies
COPY ./package.json ./setup.py /srv/VG100-elm-website/
WORKDIR /srv/VG100-elm-website

# Install node dependencies
RUN \. "$NVM_DIR/nvm.sh" && nvm use 12 && \
    npm install -g yarn --registry=https://registry.npm.taobao.org && \
    yarn global add create-elm-app elm pm2 --registry=https://registry.npm.taobao.org

RUN \. "$NVM_DIR/nvm.sh" && nvm use 12 && \
    yarn --registry=https://registry.npm.taobao.org

COPY . /srv/VG100-elm-website
RUN pip3 install -e . -i https://pypi.tuna.tsinghua.edu.cn/simple/

ENV PUBLIC_URL='/vg100'
RUN \. "$NVM_DIR/nvm.sh" && nvm use 12 && \
    node scripts/build.js

CMD \. "$NVM_DIR/nvm.sh" && nvm use 12 && \ pm2 start ./ecosystem.config.js

EXPOSE 5000

