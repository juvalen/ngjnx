$docroot = '/var/www/html'
$packages = ['curl','nginx'] 

package { $packages: 
   ensure => "installed",
}

service { 'nginx':
  ensure => running,
}

# Set nginx new configuration file
tidy { "/etc/nginx/sites-enabled/default": }
tidy { "/etc/nginx/sites-available/default": }

## Create symlink to set reverse-proxy configuration available to nginx
file { "/etc/nginx/sites-available/reverse-proxy.conf":
  ensure => 'link',
  target => "/vagrant/files/reverse-proxy.conf",
}

## Create symlink to set reverse-proxy configuration enabled to nginx
file { "/etc/nginx/sites-enabled/reverse-proxy.conf":
  ensure => 'link',
  target => "/vagrant/files/reverse-proxy.conf",
  notify  => Service['nginx'],
}

# Creates an index file for testing
file { "${docroot}/index.html":
  ensure => file,
  content => "<h1>Happy Puppet</h1>",
}
