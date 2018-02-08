suggest that you have two vip that provide the same service,such as http.
I have four RS in backend,client can access to RS by vip1 and vip2,the keepalive server will scheduling every request to the four RS by average.

every RS should config both vip

fwmark means that set mark by iptables in mangle tables 
vip1: 172.18.50.80
vip2: 172.18.50.90
the cmd is below
iptables -t mangle -A PREROUTING -d 172.18.50.80,172.18.50.90 -p tcp --dport 80 -j MARK --set-mark 6


