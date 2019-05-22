# Module juvalen/ngjnx
## Installs two proxy servers using puppet
This module installs in two boxes a reverse and a forward proxy, provided by Virtualbox and provisioned with puppet using vagrant. Based on these tools:

**nginx** works as a reverse proxy performing also some routing.

**privoxy** provides http access logs filtered.

### Requirements
* Vagrant application
* A Virtualbox appliance
* Puppet and modules installed
* Puppet nginx module installed
`$ puppet module install puppet-nginx`

### Initial configurarion
* Local network interface is **wlp16s0**
* Box network inerface is **enp0s8**

Tune them at `Vagrantfile` to target your environment.

Also create a new file with the name of your interface at the box and replace it inside the file too:

`$ cp files/listen-address-enp0s8 files/listen-address-BOX_INTERFACE_NAME`

The development was done in a `192.168.1.0` network, so for other ranges some network addresses in the configuration have to be changed.

### Operation
To build and deploy the servers clone the repository, make any neccesary adjustment mentioned before and enter:

`$ vagrant up`

and two machines will be created in Virtualbox with names:

- **reverse**

- **logproxy**

The IP address of the boxes could be retrieved at host using:

`$ NODEIP = $(vagrant ssh NODENAME -c "ip address show enp0s8 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'")`

Connect to each box using:

`$ vagrant ssh NODENAME`

## reverse: nginx as reverse proxy with routing
A reverse proxy can be accessed through virtualbox IP at port 443. From box **reverse** it can be tested:

`$ curl -k https://localhost/resource2` (dumps content of www.gg.com)

`$ curl -k https://localhost/whatever`  (dumps content of www.aaa.com)

`$ curl localhost/whatever` (dumps content from /var/www/html)

Or from other nodes in the network access:

`$ curl -k https://<NODEIP>/whatever`

The IP address of the **reverse** box could be retrieved at host using:

`$ vagrant ssh reverse -c "ip address show enp0s8 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'"`

provided the interface used in the box is **enp0s8**, fact to be retrieved from the there.

### Certificate for https
It was generated a self signed certificate in localhost at development time with:

`$ openssl req -x509 -newkey rsa:4096 -keyout cert.key -out cert.pem -days 365 -subj "/C=ES/ST=Madrid/L=Madrid/O=IT/CN=reverse"`

which produced both `cert.key` and `cert.pem` with no passphrase, to be copied to `/vagrant/files` .


## logproxy: Privoxy proxy for log analysis
Privoxy server is installed in a machine labeled **logproxy** and listening at port 8118. Browsers in the local network (192.168.1.0/24) should set their proxy address to it.

Caveat for code viewers:

_**log-proxy** tag is used in most places_

_**logproxy** without the dash is used in manifest variables and box name_

### Rationale
For this task a quick assessment of available tools was made among **tcpdump**, **getent**, **wireshark**, **ZAP**, **snort**, **squid**, **mitproxy**, **nginx** and **Postman**, being finally selected **Privoxy**. Yet comercial **nginx plus** can closely fit the requirements.

### Configuration
Proxy configuration file at files/config is copied to the node.

In config file access through the proxy is allowed to IPs in the 192.168.1.0/24.

It is currently configured to log debug levels 1, 2, 8, 512 & 65536 which provides this sample format:
> 2019-05-11 22:48:51.024 7fa925648700 Connect: Connected to www.eff.org[151.101.132.201]:443.

Listen address has to be that of the adaptor, **enp0s8** for my computer.

Logged data will be stored in `/var/log/privoxy/privoxy`

That log data can be pretty rendered on-line using the provided parser:

`$ tail -f /var/log/privoxy/privoxy | privoxy-log-parser`

The IP address of the **logproxy** box could be retrieved at host using:

`$ vagrant ssh logproxy -c "ip address show enp0s8 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'"`

## Health checking
A simple and effective method for testing the health of these services is to launch a cron managed wget query to each of the servers:

`wget https://domain.com`

`wget https://domain.com/resource2`

`export http_proxy=<LOGPROXY>:8118`

`export https_proxy=<LOGPROXY>:8118`

`wget http://abc.com`

and comparing retrieved data with a template. Alarms could be raised.

## TODOs
1. As the proxy log file provides a wealth of information and modern web page complexity, duration of TCP connections should be gathered either by off-line processing or with dedicated hardware.
1. To assess the workload supported by this architecture.
