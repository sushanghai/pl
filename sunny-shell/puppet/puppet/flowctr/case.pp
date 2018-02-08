case $operatingsystem {
	'Solaris': 			{notice("Welcome to Solaris")}
	'RedHat','CentOS':	{notice("Welcome to RedHat osfamily")}
	/^(Debian|Ubuntu)$/:{notice("Welcom to $1 linux")}
	default:			{notice("Welcome,alien *_*")}
}
