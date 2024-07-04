# Dockerfile to install Kamailio 5.7.5 from source code
# We use the debian 11
FROM debian:11

ARG KAMAILIO_SOURCE=https://github.com/kamailio/kamailio.git
ARG KAMAILIO_VERSION=5.7
WORKDIR "/build"

# Update and install required packages
RUN apt-get -qq update \
    && apt-get install -yqq --no-install-recommends --no-install-suggests \
    wget curl iputils-ping git gcc g++ flex bison default-libmysqlclient-dev \
    make autoconf libssl-dev libjansson-dev net-tools iproute2 gnupg2 tcpdump libgeoip-dev libcurl4-openssl-dev \
    python3 python3-pip libxml2-dev libpcre3-dev libevent-dev tmux\
    && echo "deb http://packages.irontec.com/debian bullseye main" >> /etc/apt/sources.lists \
    && wget http://packages.irontec.com/public.key -q -O - | apt-key add - \
    && apt-get update && apt-get install -y  sngrep \
    && pip3 install pystache PyYaml \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Clone the Kamailio repository and checkout the desired version
RUN git clone $KAMAILIO_SOURCE
WORKDIR /build/kamailio

# compile & install
RUN git checkout $KAMAILIO_VERSION \
    && make cfg \
    && make all \
    && make install

# Set the working directory for the Kamailio configuration
WORKDIR /usr/local/etc/kamailio/
