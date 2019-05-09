# Installing a reverse proxy using puppet (virtualbox provider)
This script installs nginx working as a reverse proxy with vagrant in Virtualbox.
It now works at port 80

## Requirements
A Virtualbox appliance
Puppet installed
$ puppet module install puppet-nginx --version 0.16.0 (from https://forge.puppet.com/puppet/nginx)

## Operation
Puppet needs both nginx & openssl modules installed.
$ puppet module install puppet-nginx
$ puppet module install camptocamp-openssl

To run just enter:
$ vagrant up -provision

Them from the virtual machine it can be tested:
$ curl localhost/resource2 (dumps content of www.google.com) 
$ curl localhost/whatever  (dumps content of www.gg.com) 

## Certificate
Generated in host with:
$ openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -subj "/C=ES/ST=Madrid/L=Madrid/O=IT/CN=www.ejemplo.es"
Passphrase **qwe123**

