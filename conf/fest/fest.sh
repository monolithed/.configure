#!/bin/sh

PATH='/var/log/fest /var/run/fest'

sudo mkdir -p ${PATH}
sudo touch /var/log/fest/example.com.log
sudo chmod -R u+rwX,go+rX ${PATH}

sudo ln -s /home/www/example.com/fest.py /etc/init.d/fest.py

shopt -s expand_aliases

FEST="sudo python /etc/init.d/fest.py \
    --path='/usr/local/www/example.com/conf/fest/fest.yaml' \
    --name='example.com'"

alias fest=${FEST}

# touch ~/.bash_aliases
# source ~/.bashrc

echo ${FEST} >> ~/.bashrc

fest --test
