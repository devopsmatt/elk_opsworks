# -*- mode: ruby -*-
# vim: set ft=ruby expandtab ts=4 sw=4:

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define :linux do |elk_config|
    elk_config.vm.hostname = "vagrant"
    elk_config.vm.box = "ubuntu/trusty64"
    elk_config.berkshelf.enabled = true
    elk_config.berkshelf.berksfile_path = 'Berksfile'

    elk_config.vm.boot_timeout = 600
    elk_config.vm.network :private_network, :ip => '10.10.10.10'
    elk_config.vm.network :forwarded_port, guest: 5601, host: 5601, id: "kibana", auto_correct: true
    elk_config.vm.network :forwarded_port, guest: 9200, host: 9200, id: "es", auto_correct: true

    elk_config.vm.provider "virtualbox" do |v|
      v.memory = 4096
      v.name = 'vagrant_elk'

      v.customize ['modifyvm', :id, '--cpuexecutioncap', '100']
      v.customize ['modifyvm', :id, '--cpuhotplug', 'on']
      v.customize ['modifyvm', :id, '--cpus', 1]
    end

    elk_config.vm.provision :chef_solo do |chef|
      chef.data_bags_path = ["data_bags"]
      chef.roles_path = ["roles"]
      chef.environments_path = ["environments"]
      chef.environment = 'vagrant'
      chef.add_recipe 'vel_elk::default'
    end
  end
end
