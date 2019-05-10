$log = '/var/log/nginx/proxy.log'
$packages = ['curl','privoxy'] 

package { $packages: 
   ensure => "installed",
}

#exec { 'privoxy':
#  environment => [ 'http_proxy=localhost:3128' ]
#}

file { "/etc/privoxy/config":
  ensure => 'link',
  target => "/vagrant/files/config",
  notify => Service[privoxy],
}

service { 'privoxy':
  ensure => "running",
}

