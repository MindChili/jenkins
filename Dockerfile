FROM jenkins/jenkins:2.110

LABEL maintainer="Tomasz Nassalski <tomasz.nassalski@mindchili.com>"

USER root

# Change timezone to Warsaw
RUN \
  echo "Europe/Warsaw" > /etc/timezone && \
  dpkg-reconfigure -f noninteractive tzdata && \
  ln -sf /usr/share/zoneinfo/Poland /etc/localtime

# INSTALL ADDITIONAL LIBRARIES CONNECTED WITH PHP APPLICATIONS DEPLOYMENT

RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential libssl-dev php-pear php-dev php-curl php-mbstring php-zip rsync

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
  printf "\n" | pecl install ssh2-1.1.2 && \
  echo 'extension=ssh2.so \n' >> /etc/php/7.0/cli/php.ini
  
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
  
# Install composer and set global access to it
RUN \
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
  php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
  php composer-setup.php && \
  php -r "unlink('composer-setup.php');" && \
  mv composer.phar /usr/local/bin/composer
  
# INSTALL OTHER TOOLS

RUN \
  apt-get install -y mc vim
  
USER jenkins