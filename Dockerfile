FROM jenkins:2.32.2

MAINTAINER Tomasz Nassalski <tomasz.nassalski@mindchili.com>

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential