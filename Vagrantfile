Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.network "public_network", bridge: "wlp16s0"
#    use_dhcp_assigned_default_route: true

  # Setting up an updated xenial64 machine
  config.vm.provision "shell", inline: "apt -y update && apt -y install puppet"

  config.vm.provision "puppet" do |ngjnx|
    ngjnx.manifests_path = "manifests"
    ngjnx.manifest_file = "reverse.pp"
  end

# Renames VM
  config.vm.provider :virtualbox do |vb|
    vb.name = "ubuntu-xenial"
  end

end
