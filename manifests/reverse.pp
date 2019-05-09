$packages = ['curl','nginx'] 

package { $packages: 
   ensure => "installed" 
}

service { 'nginx':
  ensure => running,
}

#file { '/var/www/html/index.html':
#  ensure => present,
#  mode => "0644",
#  owner => "root",
#  group => "root",
#  content => "<h1>Happy Puppet</h1>",
#}
