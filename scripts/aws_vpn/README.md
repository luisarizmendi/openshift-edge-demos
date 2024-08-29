



DONT USE IN PRODUCTION AWS ENVIRONMENTS


instala ocp o mete el vpc_id a mano (coge el primero si no)





vpn openwrt
-----------------------------

opkg install strongswan-minimal strongswan-mod-aes strongswan-mod-hmac strongswan-mod-sha1  kmod-ip-vti vti luci-proto-vti strongswan-mod-kdf


copy ipsec files

add interfaces and firewall rules


root@OpenWrt:~# /etc/init.d/ipsec enable
root@OpenWrt:~# /etc/init.d/ipsec restart





check logs:
  logread -f
  ipsec statusall


