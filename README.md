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


## Squid as proxy log
$ sudo apt install squid3
$ sudo vim /etc/squid/squid.conf
$ sudo systemctl restart squid.service
$ sudo systemctl disable  squid.service
$ sudo tail -f /var/log/squid/access.log

## Native proxy log
$ export http_proxy="http://localhost:4444"
$ export https_proxy="https://localhost:4444"
$ export ftp_proxy="http://localhost:4444"

## Privoxy
$ service privoxy start
$ export http_proxy=localhost:3128
$ brave-browser --proxy-server=localhost:3128 >/dev/null 2>&1 &
$ sudo /etc/privoxy/config

Configuration at http://config.privoxy.org/ doesn't work:
`Invalid header received from client.`

Log will be stored in:
`/var/log/privoxy/privoxy

It is configured to debug levels 1, 2, 8 & 128.

It can be highlighted using the parser:
`$ tail -f /var/log/privoxy/privoxy | privoxy-log-parser`



