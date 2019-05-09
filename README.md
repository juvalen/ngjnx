# Installing a reverse proxy using puppet (virtualbox provider)
 puppet module install puppet-nginx --version 0.16.0
 https://forge.puppet.com/puppet/nginx

 Now nginx running

 Trying to achieve this:
 https://stackoverflow.com/questions/24153952/how-to-define-a-second-nginx-location-clause-inside-a-puppet-vhost
 Remove the virtual host:
 * unlink /etc/nginx/sites-enabled/default

 This has to be but in /etc/nginx/sites-available/reverse-proxy.conf

server {
    # Change to 443;
    listen       80 default_server;
    server_name  _;

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

 * ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled/reverse-proxy.conf


If proxy_pass is specified without a URI, the request URI is passed to the server in the same form as sent by a client when the original request is processed, or the full normalized request URI is passed when processing the changed URI:
  location /some/path/ {
    proxy_pass http://127.0.0.1;
  }



