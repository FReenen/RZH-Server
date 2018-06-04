#/bin/bash

apt-get update
apt-get upgrade -y

apt-get install lxd

apt-get autoremove -y

lxd init

#lxc storage create SSD dir
#lxc network create brlive0 ipv4.address=10.255.255.254/16 ipv4.address=none

echo "Create containers..."
lxc launch ubuntu:18.04 proxy
lxc launch ubuntu:18.04 dns

echo "Configur Proxy..."
lxc exec proxy -- apt-get update
lxc exec proxy -- apt-get upgrade -y
lxc exec proxy -- apt-get install -y nginx
lxc file push ./proxy/newsite proxy/root/newsite
lxc file puxh ./proxy/enablesite proxy/root/enablesite
lxc exec proxy -- chmod +x /root/newsite
lxc exec proxy -- chmod +x /root/enablesite

echo "Configur DNS..."
lxc exec dns -- apt-get update
lxc exec dns -- apt-get upgrade -y
lxc exec dns -- apt-get install -y bind9
lxc exec dns -- mkdir /etc/bind/named.conf.domains
lxc exec dns -- mv /etc/bind/named.conf.options /etc/bind/named.conf.options.backup
lxc exec dns -- mv /etc/bind/named.conf.local /etc/bind/named.conf.local.backup
lxc exec dns -- mv /etc/bind/named.conf.default-zones /etc/bind/named.conf.default-zones.backup
lxc exec dns -- ./dns/*.conf.* dns/etc/nginx/
lxc file push ./dns/adddomain dns/root/adddomain
lxc exec dns -- chmod +x /root/adddomain
