#!/bin/bash

# Enable the module
echo "extension=memcached.so" | sudo tee -a /opt/build/php/7.3/etc/php.d/memcached.ini
