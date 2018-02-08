# copy file
#file{'/etc/redis.conf':
#	ensure => file,
#	source => '/root/redis.conf',
#	owner => 'redis',
#	group => 'root',
#	mode => '0644',
#}

#copy directory
#file{'yumfile':
#	ensure => directory,
#	path => '/tmp/yum.repos.d/',
#	source => '/etc/yum.repos.d/',
#	recurse => true,
#}


#copy file to directory,but only copy one file to another file at last,coulod not create directory
#file{'test':
#	ensure => directory,
#	path => '/tmp/test',
#	source => ['/etc/issue','/etc/group'],
#}

#create links
#file{'redis.conf':
#	ensure => link,
#	path => '/tmp/redis.conf',
#	target => '/etc/redis.conf',
#}

#copy file and then create links
file{'test.txt':
	path => '/tmp/test.txt',
	ensure => file,
	source => '/etc/fstab',
	before => File['test.symlink'],
}
file{'test.symlink':
	path => '/tmp/test.sysmlink',
	target => '/tmp/test.txt',
	ensure => link,
#	require => File['test.txt'],
}
