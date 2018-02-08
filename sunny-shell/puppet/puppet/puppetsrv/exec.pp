exec{'makedir':
	command => 'mkdir /tmp/hi.dir',
	path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin',
	creates => '/tmp/hi.dir',
}

exec{'createuser':
	command => 'useradd sunny88',
	path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin',
	unless => 'id sunny88',
}

exec{'installpkg':
	command => 'yum -y install tree',
	path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin',
	onlyif => 'yum repolist | grep -i sunny',
}

file{'/etc/aliases':
	path => '/etc/aliases',
	ensure => file,
	before => Exec['newaliases'],
}
exec{'newaliases':
	path => ["/usr/local/sbin","/usr/local/bin","/usr/local","/usr/bin"],
	subscribe => File["/etc/aliases"],
	refreshonly => true,
}

file{'/etc/redis.conf':
		source => '/root/redis.conf',
		ensure => file,
		notify => Exec['backupfile'],
}
exec{'mkdir':
	command => 'mkdir /backups',
	path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin',
	unless => 'ls /backups',
	before => Exec['backupfile'],
}
exec{'backupfile':
	command => "cp /etc/redis.conf /backups/redis.conf-$(date +%F-%H-%M-%S)",
	path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin',
	refreshonly => true,
#	subscribe => File['/etc/redis.conf'],
}


