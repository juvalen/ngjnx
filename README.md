# Module juvalen/ngjnx
## Instals a reverse proxy using puppet (virtualbox provider)
This module installs nginx working as a reverse proxy with vagrant in Virtualbox.

### Requirements
* A Virtualbox appliance
* Puppet and modules installed

### Operation
Puppet needs both nginx & openssl modules installed.

`$ puppet module install puppet-nginx`

`$ puppet module install camptocamp-openssl`

To construct and deploy the server just enter:
$ vagrant up -provision

Them from the virtual machine it can be tested:

`$ curl localhost/resource2 (dumps content of www.google.com)`

`$ curl localhost/whatever  (dumps content of www.gg.com)`

or access virtualbox IP at port 80. It will work with https. 

### Certificate for https
Generated ahead in host with:

`$ openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -subj "/C=ES/ST=Madrid/L=Madrid/O=IT/CN=www.ejemplo.es"`

Passphrase **qwe123**

