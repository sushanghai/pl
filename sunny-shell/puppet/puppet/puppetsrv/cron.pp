cron{'timesync':
	command => '/usr/sbin/ntpdate 172.18.50.61 &>/dev/null',
	ensure => present,
	minute =>'*/20',
	user => 'sunny',
}
