class dbserver($pkg='mariadb-server',$srv='mariadb'){
	package {"$pkg":
		ensure => latest,
		before => Service["$srv"],
	}
	service{"$srv":
		ensure => running,
	}
}
	if $operatingsystem =="CentOS" or $operatingsystem == "RedHat" {
		case $operatingsystemmajrelease {
			'7':{$pkgname = 'mariadb-server' $srvname='mariadb'}
			default:{$pkgname = 'mysql-server' $srvname='mysqld'}
		}
	}

class {'dbserver':
	pkg => "$pkgname",
	srv => "$srvname",
}
