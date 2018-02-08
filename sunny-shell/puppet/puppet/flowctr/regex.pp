#if $osfamily =~ /(?i-mx:debian)/ {
#	$webserver = 'apache2'
#} else {
#	$webserver = 'httpd'
#}


#case $osfamily {
#	"RedHat":{$webserver='httpd'}
#	/(?i-mx:debian)/: {$webserver='apache2'}
#	default : {$webserver='httpd'}
#}


$webserver = $osfamily ?{
	"RedHat" => 'httpd',
	/(?i-mx:debian)/ => 'apache2',
	default => 'httpd',
}

package {"$webserver":
	ensure => installed,
	before => [File['httpd.conf'],Service['httpd']],
}

file {'httpd.conf':
	path => '/etc/httpd/conf/httpd.conf',
	source => '/root/httpd.conf',
	ensure => file,
}

service {'httpd':
	ensure => running,
	path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin',
	enable => true,
	restart => 'systemctl restart httpd.service',
	subscribe => File['httpd.conf'],
}
