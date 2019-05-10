$docroot = '/var/www/html'
$packages = ['curl','nginx','openssl'] 

package { $packages: 
   ensure => "installed" 
}

service { 'nginx':
  ensure => running,
#  ssl => true,
#  ssl_only => true,
#  ssl_cert => 'files/cert.pem',
#  ssl_key => 'files/jey.pem',
}

tidy { '/etc/nginx/sites-available/default': }

file { "/etc/nginx/sites-available/reverse-proxy.conf":
  ensure => 'present',
#
# I had problems to send nginx configuration content so I put it inline:
# Configuration file for nginx as reverse proxy
#
  content => '
server {
  # listen	443 ssl;
  listen	80 default_server;
  server_name	_;

# Must start by /resource2
    location /resource2 {
        # Requests to resource2/ are redirected to google.com
        proxy_pass http://www.google.com/;
#        proxy_pass http://10.10.10.10/;
    }

    location / {
        # All others to gg.com
        proxy_pass http://www.gg.com/;
#        proxy_pass http://20.20.20.20/;
    }

}
'
}

file { "/etc/nginx/sites-enabled/reverse-proxy.conf":
  ensure => 'link',
  target => '/etc/nginx/sites-available/reverse-proxy.conf',
  notify  => Service['nginx'],
}

# Creates an index file for testing
file { "${docroot}/index.html":
#  ensure => present,
#  mode => "0644",
#  owner => "root",
#  group => "root",
  content => "<h1>Happy Puppet</h1>",
}
