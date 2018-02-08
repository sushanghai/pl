class instwebsvr {
$webserver = $osfamily ?{
    "RedHat" => 'httpd',
    /(?i-mx:debian)/ => 'apache2',
    default => 'httpd',
}

package {"$webserver":
    ensure => installed,
}
}
include instwebsvr
