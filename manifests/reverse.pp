$docroot = '/var/www/html'
$packages = ['curl','nginx'] 

package { $packages: 
  ensure => "installed",
}

# Creates an index file for testing
file { "${docroot}/index.html":
  ensure => file,
  content => "<h1>Happy Puppet</h1>",
}

# Create symlink to set reverse-proxy configuration available to nginx
file { "/etc/nginx/sites-available/reverse-proxy.conf":
  ensure => 'link',
  target => "/vagrant/files/reverse-proxy.conf",
}

# Create symlink to set reverse-proxy configuration enabled to nginx
file { "/etc/nginx/sites-enabled/reverse-proxy.conf":
  ensure => 'link',
  target => "/vagrant/files/reverse-proxy.conf",
}

file { "/etc/nginx/sites-available/default":
  ensure  => absent,
}

# Remove nginx default configuration file
file { "/etc/nginx/sites-enabled/default":
  ensure  => absent,
  notify  => Service['nginx'],
}

# This service is not working properly ???
# I resort to Exec
service { 'nginx':
  ensure => "running",
  enable => "true",
}

exec { 'restart-nginx':
  command => "/bin/systemctl restart nginx",
  user => "root",
}

