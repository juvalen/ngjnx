$log = '/var/log/nginx/proxy.log'
$packages = ['curl'] 

package { $packages: 
  ensure => "installed",
}

file { "/etc/privoxy/config":
  ensure => 'file',
  target => "/vagrant/files/config",
  notify => Exec[listen-address],
}

exec { 'listen-address':
  command => "listen-address-enp0s8",
  path => "/vagrant/files/",
  user => "root",
  notify => Service[privoxy],
}

service { 'privoxy':
  ensure => "running",
}

