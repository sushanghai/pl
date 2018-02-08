两台nginx服务器上分别安装keepalive,通过脚本检查keepalive 和 nginx是否存在，实现高可用。
一般只有一台keepalive的级别高，所以该机器的nginx起作用，负责调度，当nginx异常，权重减去20后，备用的keepalive起作用，备用机器删的nginx接管工作。后端的RS是定义在nginx的http配置段里

ENV:
	one host
	two nginx which also config HA: 172.18.50.63 and 172.18.50.73,nginx is used as scheduler.
	two http server :172.18.50.65,172.18.50.75.


two nginx should be config as below:
	http{
		......
		  upstream websrvs {
        server 172.18.50.75:80 weight=1;
        server 172.18.50.65:80 weight=2;
        server 127.0.0.1:8000 backup;
			}
		......
	}

	server {
		.....
			location / { 
        proxy_pass http://websrvs;
		    }   
		......
	}

HA config in 63 and 73 which config is keepalived.conf.node1 and keepalived.conf.node2

chk_down func is used to check keepalived HA,if /etc/keepalived/down file is exist,its weight will be minus 20,Another server will take over the HA job,and config the vip in it. 
chk_nginx func is used to check whether nginx is working,if nginx down ,the host's weight will be minus 20,Another server will take over the nginx job,and config the vip in it. 

