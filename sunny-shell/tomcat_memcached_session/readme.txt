URL:http://blog.51cto.com/ghbsunny/1982321
six hosts to make up the env
the network is 172.18.50.0/24
ip:
	75;	httpd server:control request to backend tomcat server by ajp
	72,73: tomcat server
	62,63: memcached server
	61:client host to test the result

These directory contains 72,73,75 relative  configuration.

62 and 63 should only need to install memcached server,did not need to config ,just start the memcached service.

72 and 73 should install tomcat server.
	file:index.jsp  is under /usr/share/tomcat/webapps/test
	file:web.xml	is under /usr/share/tomcat/webapps/test/WEB-INF
	file:server.xml is under /etc/tomcat
notice:
1: put below two jar packages about javolution  under
/usr/share/tomcat/webapps/test/WEB-INF/lib/
    javolution-5.4.3.1.jar  
    msm-javolution-serializer-2.1.1.jar
2: put below three jar packages about memcached under /usr/share/tomcat/lib/
    memcached-session-manager-2.1.1.jar
    memcached-session-manager-tc7-2.1.1.jar
    spymemcached-2.12.3.jar

75 install httpd.
	file:ajp-tomcat.conf	is under /etc/httpd/conf.d
