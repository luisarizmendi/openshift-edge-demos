




instala ocp o mete el vpc_id a mano (coge el primero si no)





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