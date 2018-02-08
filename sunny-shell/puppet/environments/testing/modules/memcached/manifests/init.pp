class memcached($maxmemory='64'){
	package{'memcached':
		ensure => latest,
		provider => yum,
	}

	file{'/etc/sysconfig/memcached':
		ensure => file,
		content => template('memcached/memcached.erb'),
		owner => 'root',
		group => 'root',
		mode => '0644',
	}
	service{'memcached':
		ensure => running,
		enable => true,
	}
   Package['memcached'] -> File['/etc/sysconfig/memcached'] ~>Service['memcached']
}
