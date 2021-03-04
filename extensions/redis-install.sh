#!/bin/bash

# Enable the module
echo "extension=redis.so" | sudo tee -a /opt/build/php/7.3/etc/conf.d/redis.ini
