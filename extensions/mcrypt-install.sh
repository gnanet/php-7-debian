#!/bin/bash

# Enable the module mcrypt
echo "extension=mcrypt.so" | sudo tee -a /opt/build/php/7.3/etc/php.d/mcrypt.ini
