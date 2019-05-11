$docroot = '/var/www/html'
$packages = ['curl','nginx'] 

package { $packages: 
  ensure => "installed",
  notify => File['/etc/nginx/sites-available/reverse-proxy.conf'],
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
  notify => File['/etc/nginx/sites-enabled/reverse-proxy.conf'],
}

# Create symlink to set reverse-proxy configuration enabled to nginx
file { "/etc/nginx/sites-enabled/reverse-proxy.conf":
  ensure => 'link',
  target => "/vagrant/files/reverse-proxy.conf",
  notify  => Tidy['/etc/nginx/sites-enabled/default'],
}

# Remove nginx default configuration file
tidy { "/etc/nginx/sites-enabled/default":
  notify  => Tidy['/etc/nginx/sites-available/default'],
}

tidy { "/etc/nginx/sites-available/default":
  notify  => Service['nginx'],
}

service { 'nginx':
  ensure => "running",
}

