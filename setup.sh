#/bin/bash

apt-get update
apt-get upgrade -y

apt-get install lxd

lxd init

#lxc storage create SSD dir
#lxc network create brlive0 ipv4.address=10.255.255.254/16 ipv4.address=none

# create Proxy
lxc launch ubuntu:18.04 proxy #boot.autostart=true \
    #nictype=bridged parent=brlive0 ipv4.address=10.255.0.1/16
lxc exec proxy -- apt-get update
lxc exec proxy -- apt-get upgrade -y
lxc exec proxy -- apt-get install nginx
lxc file push ./proxy/newsite proxy/root/newsite
lxc file puxh ./proxy/enablesite proxy/root/enablesite
lxc exec proxy -- chmod +x /root/newsite
lxc exec proxy -- chmod +x /root/enablesite

# create DNS
lxc lanch ubuntu:18.04 dns #boot.autostart=true \
    #nictype=bridged parent=brlive0 ipv4.address=10.255.0.11/16
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
