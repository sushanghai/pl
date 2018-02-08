The keepalive_project is use to build an A/A module
There are two vip:
	vip1:172.18.50.80/32
	vip2:172.18.50.90/32
	both  vip1 and vip2 prefix should be 32,it will affect the result if it
	was not 32
There are two keepalive node,and lvs mode is configed on them
	node1:172.18.50.63
	node2:172.18.50.73
There are two RS:
	RS1:172.18.50.65
	RS2:172.18.50.75


Be careful about the mask in vip，it will affect the result,most in the route
path.
If you have many vip,suggest you to prepare different notify.sh to distinguish
different host

