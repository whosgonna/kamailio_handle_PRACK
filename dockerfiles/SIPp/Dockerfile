# Dockerfile to install SIPp v3.7.1
# We use the debian 11
FROM debian:11

# Set Work Directory
WORKDIR /tools

# Install required packages and SIPp
RUN apt-get update -qq\
    && apt-get -yqq --no-install-recommends install \
    sipsak nmap net-tools python3 python3-pip\
    tcpdump git gcc g++ cmake make libncurses5-dev libncursesw5-dev build-essential \
    iputils-ping \
    && git clone https://github.com/SIPp/sipp.git /tools/sipp \
    && cd /tools/sipp \
    && git checkout v3.7.0_rc1 \
    && cmake . \
    && make . \
    && make install \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
