




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
