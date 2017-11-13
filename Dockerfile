FROM jenkins/jenkins:lts:2.73.3

MAINTAINER Tomasz Nassalski <tomasz.nassalski@mindchili.com>

USER root

# Change timezone to Warsaw
RUN \
  echo "Europe/Warsaw" > /etc/timezone && \
  dpkg-reconfigure -f noninteractive tzdata

# INSTALL ADDITIONAL LIBRARIES CONNECTED WITH PHP APPLICATIONS DEPLOYMENT

RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential libssl-dev php-pear php5-dev php5-curl rsync

# Install and configure libssh
RUN \
  wget https://www.libssh2.org/download/libssh2-1.8.0.tar.gz -P /var/lib && \
  tar xvzf /var/lib/libssh2-1.8.0.tar.gz -C /var/lib && \
  rm -f /var/lib/libssh2-1.8.0.tar.gzn && \
  cd /var/lib/libssh2-1.8.0 && \
  chmod +x configure && \
  ./configure && \
  make && \
  make install && \
  printf "\n" | pecl install ssh2-0.13 && \
  echo 'extension=ssh2.so \n' >> /etc/php5/cli/php.ini
  
# Install phing and other libraries with pear
RUN \
  pear upgrade --force http://pear.php.net/get/PEAR-1.10.3 && \
  pear channel-discover pear.phing.info && \
  pear install [--alldeps] phing/phing && \
  pear install VersionControl_SVN-0.5.1 && \
  pear install Net_FTP && \
  pear install Net_Socket && \
  pear install Net_SMTP && \
  pear install Mail
  
USER jenkins