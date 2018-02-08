#$pkgname = 'tree'
#package{'installpkg':
#	name => "$pkgname",
#	ensure => latest,
#}


$pkgname = 'tree'
package{"$pkgname":
	ensure => latest,
}
