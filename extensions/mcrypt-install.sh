#!/bin/bash

if [ ! -x /opt/build/php/7.3/lib/php/modules/mcrypt.so ];then chmod +x /opt/build/php/7.3/lib/php/modules/mcrypt.so; fi

echo "# Enable the module mcrypt" | sudo tee /opt/build/php/7.3/etc/php.d/mcrypt.ini
echo "extension=mcrypt.so" | sudo tee -a /opt/build/php/7.3/etc/php.d/mcrypt.ini

/etc/init.d/php7.3-fpm restart
