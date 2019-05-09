$packages = ['curl','nginx'] 

package { $packages: 
   ensure => "installed" 
}

service { 'nginx':
  ensure => running,
}

tidy { '/etc/nginx/sites-available/default': }

file { "/etc/nginx/sites-available/reverse-proxy.conf":
  ensure => 'present',
# nginx configuration content
  content => '
server {
    # Change to 443;
    listen       80 default_server;
    server_name  _;

# Must start by /resource2
    location /resource2 {
        # Requests to resource2/ are redirected to google.com
        proxy_pass http://www.google.com/;
#        proxy_pass http://10.10.10.10/;
    }

    location / {
        # All others to aaa.com
        proxy_pass http://www.aaa.com/;
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
file { '/var/www/html/index.html':
  ensure => present,
  mode => "0644",
  owner => "root",
  group => "root",
  content => "<h1>Happy Puppet</h1>",
}
