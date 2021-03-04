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



/etc/init.d/php7.3-fpm stop
rm -r /opt/build/php/7.3
update-rc.d php7.3-fpm remove
rm /etc/init.d/php7.3-fpm
