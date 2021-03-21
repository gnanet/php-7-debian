#!/bin/bash

# Add config files
echo "extension=imagick.so" | sudo tee -a /opt/build/php/7.3/etc/php.d/imagick.ini
