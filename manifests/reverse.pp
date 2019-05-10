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
###
### I had problems to send nginx configuration content so I put it inline:
### Configuration file for nginx as reverse proxy
### Former triel failed due to lack of directory /etc/nginx/...
### Now I ensure the service is running
###
##  content => "
##server {
##  # listen	80;
##  listen	443;
##  server_name	ubuntu-xenial;
##
##  ssl_certificate           /vagrant/files/cert.pem;
##  ssl_certificate_key       /vagrant/files/cert.key;
##
##  ssl on;
##  ssl_session_cache  builtin:1000  shared:SSL:10m;
##  ssl_protocols  TLSv1 TLSv1.1 TLSv1.2;
##  ssl_ciphers HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4;
##  ssl_prefer_server_ciphers on;
##
### Must start by /resource2
##    location /resource2 {
##        # Requests to resource2/ are redirected to google.com
##        proxy_pass http://www.google.com/;
###        proxy_pass http://10.10.10.10/;
##    }
##
##    location / {
##        # All others to gg.com
##        proxy_pass http://www.gg.com/;
###        proxy_pass http://20.20.20.20/;
##    }
##
##}",
#
# Creates an index file for testing
file { "${docroot}/index.html":
  ensure => file,
  content => "<h1>Happy Puppet</h1>",
}
