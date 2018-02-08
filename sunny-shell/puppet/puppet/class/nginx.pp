class nginx {
	package{'nginx':
		ensure => latest;
	} ->
	file{'/etc/nginx/nginx.conf':
		ensure => file,
		content => template('/root/nginx.conf.erb'),
	} ~>
	service{'nginx':
		ensure => running,
	}
}

include nginx
