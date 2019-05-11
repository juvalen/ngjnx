# Module juvalen/ngjnx
## Installs two proxies using puppet
This module installs a reverse and a forward proxy with puppet and vagrant in Virtualbox.

**nginx** works as a reverse proxy doing also some routing.

**privoxy** provides http access logs filtered.

### Requirements
* A Virtualbox appliance
* Puppet and modules installed
* Puppet nginx module installed
`$ puppet module install puppet-nginx`

### Operation
To build and deploy the servers just enter:
`$ vagrant up -provision`

## reverse: nginx as reverse proxy with routing
From the virtual machine it can be tested:

`$ curl localhost/whatever (dumps local content from /var/www/html)`

or accessing virtualbox IP at port 80. It works with https as:

`$ curl -k https://localhost/resource2 (dumps content of www.google.com)`

`$ curl -k https://localhost/whatever  (dumps content of www.gg.com)`


The IP address of the box could be retrieved from host using:

`vagrant ssh -c "ip address show enp0s8 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'"`

provided the interface used in the box is **enp0s8**.

### Certificate for https
Generated ahead in host with:

`$ openssl req -x509 -newkey rsa:4096 -keyout cert.key -out cert.pem -days 365 -subj "/C=ES/ST=Madrid/L=Madrid/O=IT/CN=ubuntu-xenial"`

which produced both cert.key and cert.pem in `/vagrant/files` with no passphrase.


## log-proxy Privoxy proxy for log analysis
Privoxy server is installed in a machine labeled "log-proxy" and listening at port 3128. Browsers in the local network (192.168.1.0/24) should set their proxy address to that box and port.

Config file at files/config containing all the proxy configuration will be copied in the node.

In config file access through the proxy is allowed to IPs in the 192.168.1.0/24.

It is configured to log debug levels 1, 2, 8 & 128.

Listen address has to be that of the adaptor, enp0s8 for my computer.

Logged data will be stored in:
`/var/log/privoxy/privoxy

That log data can be highlighted on-line using the provided parser:
`$ tail -f /var/log/privoxy/privoxy | privoxy-log-parser`

