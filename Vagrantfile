Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  # Setting up an updated xenial64 machine
  config.vm.provision "shell", inline: "apt -y update && apt -y install puppet"

  config.vm.provision "puppet" do |ngjnx|
    ngjnx.manifests_path = "manifests"
    ngjnx.manifest_file = "reverse.pp"
  end

# Renames VM
  config.vm.provider :virtualbox do |vb|
      vb.name = "ngjnx"
  end

end
