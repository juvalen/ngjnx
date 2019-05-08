Vagrant.configure("2") do |config|

  config.vm.provision "shell", inline: "apt -y update && apt -y install puppet"

  config.vm.box = "ubuntu/xenial64"
  config.vm.provision "puppet" do |puppet|
    puppet.facter = {
      "vagrant" => "1"
    }
  end

end
