class ngjnx {
  tidy { '/etc/nginx/sites-available/default': }

  file { "/etc/nginx/sites-available/reverse-proxy.conf":
    ensure => 'present',
    source => 'puppet:///modules/ngjnx/reverse-proxy.conf',
  }
}
