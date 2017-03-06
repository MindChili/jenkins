FROM jenkins:2.32.2

MAINTAINER Tomasz Nassalski <tomasz.nassalski@mindchili.com>

USER root

# INSTALL ADDITIONAL LIBRARIES CONNECTED WITH PHP APPLICATIONS DEPLOYMENT

RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential && \
  apt-get install -y libssl-dev && \
  apt-get install -y php-pear

# Install and configure libssh
RUN \
  wget https://www.libssh2.org/download/libssh2-1.8.0.tar.gz -P /var/lib && \
  tar xvzf /var/lib/libssh2-1.8.0.tar.gz -C /var/lib && \
  rm -f /var/lib/libssh2-1.8.0.tar.gzn && \
  cd /var/lib/libssh2-1.8.0 && \
  chmod +x configure && \
  ./configure && \
  make && \
  make install
  
# Install phing and other libraries with pear
RUN \
  pear channel-discover pear.phing.info && \
  pear install [--alldeps] phing/phing && \
  pear install VersionControl_SVN-0.5.1 && \
  pear install Net_FTP
  
USER jenkins