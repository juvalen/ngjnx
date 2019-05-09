Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  # Setting up an updated xenial64 machine
  config.vm.provision "shell", inline: "apt -y update && apt -y install puppet"

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file = "reverse.pp"
  end

#  config.vm.provision "shell", inline: "cp /vagrant/files/reverse-proxy.conf /etc/nginx/sites-available/"
#  config.vm.provision "shell", inline: "ln -s /etc/nginx/sites-available/reverse-proxy.conf /etc/nginx/sites-enabled"

# Renames VM
  config.vm.provider :virtualbox do |vb|
      vb.name = "nginx_puppet"
  end

end
