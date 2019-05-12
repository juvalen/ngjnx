$log = '/var/log/nginx/proxy.log'
$packages = ['curl','privoxy']

package { $packages: 
  ensure => "installed",
}

file { "/etc/privoxy/config":
  ensure => 'present',
  source => "/vagrant/files/config",
  owner => "vagrant",
  notify => Service[privoxy],
#  notify => Exec[listen-address],
}

exec { 'listen-address':
  command => "/vagrant/files/listen-address-enp0s8",
  user => "root",
  notify => Service[privoxy],
}

service { 'privoxy':
  ensure => "running",
}

