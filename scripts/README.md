




selinux



check bridge, maybe delete nmcli connection eth (script deletes nm con with same name than interface)



dhcp en el bridge -> no wifi
dhcp static


❯ ip -o -br a
lo               UNKNOWN        127.0.0.1/8 ::1/128 
wlp59s0          UP             192.168.1.40/24 fe80::341f:eca3:e1a7:c6bb/64 
virbr1           DOWN           192.168.100.1/24 
tailscale0       UNKNOWN        fe80::7a57:60fb:9fd9:1f81/64 
virbr2           DOWN           
virbr3           DOWN           192.168.99.254/24 
virbr0           DOWN           192.168.122.1/24 
virbr5           DOWN           192.168.150.1/24 
podman0          UP             10.88.0.1/16 fe80::e873:22ff:fe6e:95e3/64 
veth0@if2        UP             fe80::c80f:faff:feec:a250/64 
enp58s0u1u2      UP             
virbr10          DOWN           192.168.123.1/24 
sno-ztp-br       UP             192.168.140.231/24 fdff:7dd7:a83c::1d0/128 fdff:7dd7:a83c:0:9a73:df29:5bfb:1de6/64 fe80::5844:39f9:57c4:11e9/64 





inbound nat:
8000 -> laptop
6443 -> sno VM (with bridge)












-----------


vpn openwrt

opkg install strongswan-default ip iptables-mod-nat-extra djbdns-tools


--> https://openwrt.org/docs/guide-user/services/vpn/strongswan/configuration

/etc/config/ipsec
******


/etc/config/firewall

config 'zone'
  option 'name' 'vpn'
  option 'network' 'xfrm0'
  option 'input' 'ACCEPT'
  option 'output' 'ACCEPT'
  option 'forward' 'ACCEPT'
  option 'mtu_fix' '1'
 
config 'forwarding'
  option 'src' 'lan'
  option 'dest' 'vpn'
 
config 'forwarding'
  option 'src' 'vpn'
  option 'dest' 'lan'
 
config 'rule'
  option 'name' 'Allow-IPSec-ESP'
  option 'src' 'wan'
  option 'proto' 'esp'
  option 'family' 'ipv4'
  option 'target' 'ACCEPT'
 
config 'rule'
  option 'name' 'Allow-ISP-ISAKMP'
  option 'src' 'wan'
  option 'src_port' '500'
  option 'dest_port' '500'
  option 'proto' 'udp'
  option 'family' 'ipv4'
  option 'target' 'ACCEPT'




/etc/config/network

config 'interface' 'xfrm0'
  option 'ifid' '357'
  option 'tunlink' 'serrada'
  option 'mtu' '1438'
  option 'zone' 'vpn'
  option 'proto' 'xfrm'
  # useful if you want to run Bonjour/mDNS across VPN tunnels
  option 'multicast' 'true'
 
config 'interface' 'xfrm0_s'
  option 'ifname' '@xfrm0'
  option 'proto' 'static'
  option 'ipaddr' '169.254.36.109/30'
 
config 'route'
  option 'interface' 'xfrm0'
  option 'target' '10.0.0.0/8'
  option 'source' '192.168.140.1'



/etc/init.d/swanctl enable
/etc/init.d/swanctl restart

/etc/init.d/firewall restart
/etc/init.d/network restart