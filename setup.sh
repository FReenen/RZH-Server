#/bin/bash

apt-get update
apt-get upgrade -y

apt-get install lxd

lxc storage create SSD dir
#TODO: add IP and NAT.
lxc network create brlive0

# create proxy
lxc launch ubuntu:18.04 proxy
lxc exec proxy -- apt-get update
lxc exec proxy -- apt-get upgrade -y
lxc exec proxy -- apt-get install nginx
lxc file push ./proxy/newsite proxy/root/newsite
lxc file puxh ./proxy/enablesite proxy/root/enablesite
lxc exec proxy -- chmod +x /root/newsite
lxc exec proxy -- chmod +x /root/enablesite

# create DNS
lxc lanch ubuntu:18.04 dns
lxc exec dns -- apt-get update
lxc exec dns -- apt-get upgrade -y
lxc exec dns -- apt-get install bind9
lxc exec dns -- mkdir /etc/bind/named.conf.domains
lxc exec dns -- mv /etc/bind/named.conf.options /etc/bind/named.conf.options.backup
lxc exec dns -- mv /etc/bind/named.conf.local /etc/bind/named.conf.local.backup
lxc exec dns -- mv /etc/bind/named.conf.default-zones /etc/bind/named.conf.default-zones.backup
lxc exec dns -- ./dns/*.conf.* dns/etc/nginx/
lxc file push ./dns/adddomain dns/root/adddomain
lxc exec dns -- chmod +x /root/adddomain
