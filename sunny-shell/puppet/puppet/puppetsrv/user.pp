#There are two methods to solve dependency
# method 1:

#group{'testgrp':
#	ensure => present,
#}
#
#user{'myuser':
#	ensure => present,
#	name => 'sunny66',
#	uid => 3333,
#	shell => '/sbin/nologin',
#	groups => [sunnygrp,testgrp],
#	require => [Group['sunnygrp'],Group['testgrp']],
#}
#
#group{'sunnygrp':
#	ensure => present,
#	system => true,
#	name => 'sunnygrp',
#}

#method 2
group{'testgrp1':
	ensure => present,
	before => User['myuser1'],
}

user{'myuser1':
	ensure => present,
	name => 'sunny666',
	uid => 2222,
	shell => '/sbin/nologin',
	groups => [sunnygrp1,testgrp1],
#	require => [Group['sunnygrp'],Group['testgrp']],
}

group{'sunnygrp1':
	ensure => present,
	system => true,
	name => 'sunnygrp1',
	before => User['myuser1'],
}
