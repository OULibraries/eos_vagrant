# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure(2) do |config|
  config.vm.box = "phusion/ubuntu-14.04-amd64"

  config.vm.hostname = "eos.vm"

  config.vm.network "private_network", type: "dhcp"
  
  config.vm.synced_folder ".", "/vagrant", type: "nfs"
  config.bindfs.bind_folder "/vagrant/srv/eos", "/srv/eos", :force_user =>"www-data"

  home_dir = "/home/vagrant"

  config.vm.provision :shell, :path => "bootstrap.sh", :args => home_dir
  config.vm.provision :shell, :path => "eos.sh", :args => home_dir
  
end
