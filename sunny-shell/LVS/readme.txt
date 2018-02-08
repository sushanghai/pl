suggest there are five host
net:
private : 192.168.32.0/24
WAN1: 172.18.0.0/16
WAN2: 10.10.10.0/24
VIP:10.10.10.10

netcard config in every host:
host1-->client: eth1: 172.18.50.65/16
host2-->ROUTER: WAN: eth1:172.18.50.62/16
        LAN: eth0:192.168.32.62/24
		     eth0:1 : 10.10.10.12/24
host3-->VS: eth33:192.168.32.72/24
            eth33:1 10.10.10.10/24
host4-->RS1:eth0:192.168.32.63/24
            lo:1 10.10.10.10/24
host5-->RS2:eth33:192.168.32.73/24
            lo:1 10.10.10.10/24

route config,pay attention,route is very important to the lab,be careful.

both VS and RS should add default route which gateway is ROUTER's LAN card,here is 192.168.32.62
add default route cmd is "route add default gw 192.168.32.62"

I use cmd "route -n" to show all route in every host
host1-->client:
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
172.18.0.0      0.0.0.0         255.255.0.0     U     0      0        0 eth1
0.0.0.0         172.18.50.62    0.0.0.0         UG    0      0        0 eth1

host2-->ROUTER:
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
192.168.32.0    0.0.0.0         255.255.255.0   U     0      0        0 eth0
10.10.10.0      0.0.0.0         255.255.255.0   U     0      0        0 eth0
172.18.0.0      0.0.0.0         255.255.0.0     U     0      0        0 eth1
0.0.0.0         172.18.0.1      0.0.0.0         UG    0      0        0 eth1

            
host3-->VS: 
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.32.62   0.0.0.0         UG    0      0        0 ens33
10.10.10.0      0.0.0.0         255.255.255.0   U     0      0        0 ens33
192.168.32.0    0.0.0.0         255.255.255.0   U     100    0        0 ens33

            
host4-->RS1:
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
10.10.10.10     0.0.0.0         255.255.255.255 UH    0      0        0 lo
192.168.32.0    0.0.0.0         255.255.255.0   U     0      0        0 eth0
0.0.0.0         192.168.32.62   0.0.0.0         UG    0      0        0 eth0

host5-->RS2:
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.32.62   0.0.0.0         UG    0      0        0 ens33
10.10.10.10     0.0.0.0         255.255.255.255 UH    0      0        0 lo
192.168.32.0    0.0.0.0         255.255.255.0   U     100    0        0 ens33

