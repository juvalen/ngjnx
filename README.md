# Module juvalen/ngjnx
## Instals a reverse proxy using puppet (virtualbox provider)
This module installs nginx working as a reverse proxy with vagrant in Virtualbox.

### Requirements
* A Virtualbox appliance
* Puppet and modules installed

### Operation
Puppet needs nginx module installed.

`$ puppet module install puppet-nginx`

To construct and deploy the server just enter:
$ vagrant up -provision

Them from the virtual machine it can be tested:

`$ curl localhost/resource2 (dumps content of www.google.com)`

`$ curl localhost/whatever  (dumps content of www.gg.com)`

or access virtualbox IP at port 80. It works with https. 

The IP address of the box could be retrieve from host using:

`vagrant ssh -c "ip address show enp0s8 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'"`

provided the interface used in the box in **enp0s8**.

### Certificate for https
Generated ahead in host with:

`$ openssl req -x509 -newkey rsa:4096 -keyout cert.pem -out cert.pem -days 365 -subj "/C=ES/ST=Madrid/L=Madrid/O=IT/CN=ubuntu-xenial"`

which generated both cert.key and cert.pem in `/vagrant/files` with no passphrase.

