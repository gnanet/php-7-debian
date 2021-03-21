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

# Create a dir for storing PHP module conf
if [ ! -d /opt/build/php/7.3/etc/php.d ]; then
    mkdir -p /opt/build/php/7.3/etc/php.d
fi

# Add config files
sed -e "s|expose_php = On|expose_php = Off|g" -e "s|post_max_size = 8M|post_max_size = 32M|g" -e "s|upload_max_filesize = 2M|upload_max_filesize = 32M|g" -e "s|mail.add_x_header = Off|mail.add_x_header = On|g" php-src/php.ini-production > /opt/build/php/7.3/etc/php.ini
if [ -f /etc/timezone ]; then
    if [[ "x$(grep -oE "^[A-Za-z]+/[A-Za-z]+$" /etc/timezone)" != "x" ]]; then
        sed -i -e "s|;date.timezone =|date.timezone = $(cat /etc/timezone)|g" /opt/build/php/7.3/etc/php.ini
    fi
fi

if [ -d /opt/build/php/7.3/lib/php/modules ]; then
    cd /opt/build/php/7.3/lib/php/modules
    ls -1 *.so | while read tm; do
        echo "; Enable $(basename ${tm} .so) extension module" > /opt/build/php/7.3/etc/php.d/$(basename ${tm} .so).ini
        if [[ "${tm}" == "opcache.so" ]]; then
        echo "; Enable $(basename ${tm} .so) extension module" > /opt/build/php/7.3/etc/php.d/10_$(basename ${tm} .so).ini
            echo "zend_extension=${tm}" >> /opt/build/php/7.3/etc/php.d/10_$(basename ${tm} .so).ini
        elif [[ "${tm}" == "mysqlnd.so" ]]; then
        echo "; Enable $(basename ${tm} .so) extension module" > /opt/build/php/7.3/etc/php.d/20_$(basename ${tm} .so).ini
            echo "extension=${tm}" >> /opt/build/php/7.3/etc/php.d/20_$(basename ${tm} .so).ini
        else
            echo "extension=${tm}" >> /opt/build/php/7.3/etc/php.d/$(basename ${tm} .so).ini
        fi
    done
    cd -
fi

cp conf/www.conf /opt/build/php/7.3/etc/php-fpm.d/www.conf
cp conf/php-fpm.conf /opt/build/php/7.3/etc/php-fpm.conf

# Add the init script
cp conf/php7.3-fpm.init /etc/init.d/php7.3-fpm
chmod +x /etc/init.d/php7.3-fpm
update-rc.d php7.3-fpm defaults

# Start
/etc/init.d/php7.3-fpm start
