#!/bin/bash


nft add table ip wireguard
nft add chain ip wireguard prerouting { type nat hook prerouting priority -100 \; }
nft add chain ip wireguard postrouting { type nat hook postrouting priority 100 \; }
nft add chain ip wireguard wireguard_chain {type nat hook postrouting priority srcnat\; policy accept\;}
nft add rule ip wireguard prerouting tcp dport 443 dnat to 10.7.0.2
nft add rule ip wireguard postrouting ip daddr 10.7.0.2 masquerade
nft add rule ip wireguard wireguard_chain counter packets 0 bytes 0 masquerade
nft add table ip6 wireguard
nft add chain ip6 wireguard wireguard_chain {type nat hook postrouting priority srcnat\; policy accept\;}
nft add rule ip6 wireguard wireguard_chain counter packets 0 bytes 0 masquerade

echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/95-IPv4-forwarding.conf
sysctl -p /etc/sysctl.d/95-IPv4-forwarding.conf
