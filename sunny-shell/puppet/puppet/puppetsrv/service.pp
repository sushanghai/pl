#service with require
#service{'redis':
#	ensure => running,
#	enable => true,
#	hasrestart => true,
#	restart => 'systemctl restart redis',
#	require => Package['redis'],
#}
#package{'redis':
#	ensure => latest,
#}


#service with notify or subscribe
package{'redis':
	ensure => latest,
}
file{'redis.conf':
	path => '/etc/redis.conf',
	source => '/root/redis.conf',
	ensure => file,
	mode => '0644',
	owner => redis,
	group => root,
	#notify => Service['redis'],
	tag => 'cpfile',
}

service{'redis':
	ensure => running,
	enable => true,
	hasrestart => true,
	restart => 'systemctl restart redis',
#	subscribe => File['redis.conf'],
	tag => 'onlyrestart',
}
Package['redis'] -> File['redis.conf'] ~> Service['redis']

