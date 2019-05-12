# Module juvalen/ngjnx
## Installs two proxies using puppet
This module installs a reverse and a forward proxy with puppet and vagrant in in two boxes with Virtualbox provider.

**nginx** works as a reverse proxy doing also some routing.

**privoxy** provides http access logs filtered.

### Requirements
* A Virtualbox appliance
* Puppet and modules installed
* Puppet nginx module installed
`$ puppet module install puppet-nginx`

### Initial configurarion
* Local network interface is wlp16s0
* Box network inerface is enp0s8

Tune them to target environment at `Vagrantfile`.

Also create a new file with the name of your interface at the box and replace it inside the file too. Use `files/listen-address-enp0s8` as a template.

The development was done in a `192.168.1.0` network, so for other ranges some network addresses in the configuration have to be changed.

### Operation
To build and deploy the servers clone the repository, make any neccesary adjustment mentioned before and enter:

`$ vagrant up`

and two machines will be created in Virtualbox with names:

- **reverse**

- **logproxy**

Connect to each machine using:

`$ vagrant ssh NAME`

## reverse: nginx as reverse proxy with routing
From the virtual machine it can be tested:

`$ curl localhost/whatever` (dumps local content from /var/www/html)

or accessing virtualbox IP at port 80. It works with https as:

`$ curl -k https://localhost/resource2` (dumps content of www.google.com)

`$ curl -k https://localhost/whatever`  (dumps content of www.gg.com)

Or from other nodes in the network:

`$ curl -k https://<IP>/whatever`

The IP address of the box could be retrieved from host using:

`$ vagrant ssh -c "ip address show enp0s8 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'"`

provided the interface used in the box is **enp0s8**, fact to be retrieved from the machine.

### Certificate for https
It was generated in localhost at development time with:

`$ openssl req -x509 -newkey rsa:4096 -keyout cert.key -out cert.pem -days 365 -subj "/C=ES/ST=Madrid/L=Madrid/O=IT/CN=ubuntu-xenial"`

which produced both `cert.key` and `cert.pem` in `/vagrant/files` with no passphrase.


## logproxy: Privoxy proxy for log analysis
Privoxy server is installed in a machine labeled *logproxy* and listening at port 8118. Browsers in the local network (192.168.1.0/24) should set their proxy address to that box and port.

_**log-proxy** tag is used everywhere_

_**logproxy** without the dash is used in manifest variables and box name_

### Rationale
For this task a rapid assessment of available tools was made among **tcpdump**, **getent**, **wireshark**, **ZAP**, **snort**, **squid**, **mitproxy**, **nginx** and **Postman**, being finally selected **Privoxy**.

### Configuration
Proxy configuration file at files/config is copied to the node.

In config file access through the proxy is allowed to IPs in the 192.168.1.0/24.

It is configured to log debug levels 1, 2, 8, 512 & 65536 which provides this sample format:
>2019-05-11 22:48:51.024 7fa925648700 Connect: Connected to www.eff.org[151.101.132.201]:443.

Listen address has to be that of the adaptor, **enp0s8** for my computer.

Logged data will be stored in `/var/log/privoxy/privoxy`

That log data can be pretty rendered on-line using the provided parser:

`$ tail -f /var/log/privoxy/privoxy | privoxy-log-parser`

## Health testing
A simple and effective method for testing the health of these services is to launch a cron managed wget query to each of the servers:

`wget https://domain.com`

`wget https://domain.com/resource2`

`export http_proxy=<LOGPROXY>:8118`

`export https_proxy=<LOGPROXY>:8118`

`wget http://abc.com`

and compare the return with a template. Alarms could be raised.

## TODOs
1. As the proxy log file provides a wealth of information and modern web page complexity, duration of TCP connections should be gathered either by off-line processing or with dedicated hardware.
1. To assess the workload supported by this architecture.
