class redis {
	package{'redis':
		ensure => latest,
		before => Service['redis'],
	}
	service{'redis':
		ensure => running,
		enable => true,
		hasrestart => true,
		restart => 'service redis restart',
		require => Package['redis'],
	}
}

class redis::master inherits redis {
	file{'/etc/redis.conf':
		ensure => file,
		source => '/root/puppet/redis.module/redis-master.conf',
		owner => redis,
		group => root,
		require => Package['redis'],
	}
	Service['redis'] {
		restart => 'systemctl restart redis.service',
		subscribe => File['/etc/redis.conf'],
	}
}

include redis::master 
