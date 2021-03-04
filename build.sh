#!/bin/bash

if [ -x /usr/bin/lsb_release ]; then
    if [[ "x$(lsb_release -sc)" != "xwheezy"  ]]; then
        echo "This version of the script was designed for Debian Wheezy!"
        exit 127
    fi
elif [ -f /etc/issue.net ]; then
    if [[ "x$(grep -o "Debian GNU/Linux 7" /etc/issue.net)" == "x" ]]; then
        echo "This version of the script was designed for Debian Wheezy!"
        exit 127
    fi
else
    echo "This version of the script was designed for Debian Wheezy!"
    exit 127
fi


cd "$(dirname "$0")"

# Use all cores for the build process
CORE_COUNT=$(cat /proc/cpuinfo | grep -c processor)

# Allow JOB_COUNT environment variable to override the job count
JOB_COUNT=${JOB_COUNT:-$CORE_COUNT}

# Dependencies
sudo apt-get update
sudo apt-get install -y \
    build-essential \
    pkg-config \
    git \
    autoconf \
    bison \
    re2c \
    libonig-dev \
    libsqlite3-dev \
    libxml2-dev \
    libbz2-dev \
    libicu-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libltdl-dev \
    libjpeg8-dev \
    libpng12-dev \
    libpspell-dev \
    libreadline-dev

if [ ! -d /opt/build/php/7.3 ]; then
    sudo mkdir /opt/build/php/7.3
fi

git clone https://github.com/php/php-src.git
cd php-src
git fetch --tags --prune
git checkout tags/php-7.3.27
./buildconf --force

CONFIGURE_STRING="--prefix=/opt/build/php/7.3 \
                  --libexecdir=/opt/build/php/7.3/lib \
                  --datadir=/opt/build/php/7.3/share \
                  --libdir=/opt/build/php/7.3/lib/x86_64-linux-gnu \
                  --infodir=/opt/build/php/7.3/share/info \
                  --mandir=/opt/build/php/7.3/share/man \
                  --build=x86_64-linux-gnu \
                  --host=x86_64-linux-gnu \
                  --with-layout=GNU \
                  --disable-debug \
                  --enable-huge-code-pages \
                  --with-config-file-path=/opt/build/php/7.3/etc \
                  --with-config-file-scan-dir=/opt/build/php/7.3/etc/conf.d \
                  --enable-bcmath=shared \
                  --with-bz2 \
                  --enable-calendar \
                  --enable-intl=shared \
                  --enable-json=shared \
                  --enable-exif \
                  --enable-dba=shared \
                  --enable-ftp \
                  --with-gettext \
                  --with-gd=shared \
                  --with-jpeg-dir=/usr \
                  --enable-mbstring=shared \
                  --with-mhash \
                  --enable-mysqlnd=shared \
                  --with-mysqli=shared,mysqlnd \
                  --with-mysql-sock=yes \
                  --with-pdo-mysql=shared,mysqlnd \
                  --with-openssl \
                  --enable-pcntl \
                  --with-pspell=shared \
                  --enable-shmop \
                  --enable-soap=shared \
                  --enable-sockets \
                  --enable-sysvmsg=shared \
                  --enable-sysvsem=shared \
                  --enable-sysvshm=shared \
                  --enable-wddx \
                  --with-zlib \
                  --enable-zip=shared \
                  --without-libzip \
                  --with-readline \
                  --with-curl=shared,/usr \
                  --enable-fpm \
                  --with-fpm-user=www-data \
                  --with-fpm-group=www-data"

./configure $CONFIGURE_STRING EXTENSION_DIR=/opt/build/php/7.3/lib/php/modules

make -j "$JOB_COUNT"
sudo make install
