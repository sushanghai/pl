if $osfamily == 'RedHat' {
	$apachename = 'httpd'
} elsif $osfamily == 'Windows' {
	$apachename = 'apache'
} else {
	$apachename = 'httpd'
}
package {"$apachename":
	ensure => latest,
}
