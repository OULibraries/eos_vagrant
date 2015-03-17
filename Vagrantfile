# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure(2) do |config|
  config.vm.box = "phusion/ubuntu-14.04-amd64"
   config.vm.hostname = "eos.vm"

  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box
    
    # OPTIONAL: If you are using VirtualBox, you might want to use that to enable
    # NFS for shared folders. This is also very useful for vagrant-libvirt if you
    # want bi-directional sync
    config.cache.synced_folder_opts = {
      type: :nfs,
      # The nolock option can be useful for an NFSv3 client that wants to avoid the
      # NLM sideband protocol. Without this option, apt-get might hang if it tries
      # to lock files needed for /var/cache/* operations. All of this can be avoided
      # by using NFSv4 everywhere. Please note that the tcp option is not the default.
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
    # For more information please check http://docs.vagrantup.com/v2/synced-folders/basic_usage.html
  end



  if Vagrant.has_plugin?("landrush")

    config.landrush.tld = 'vm'
    config.landrush.enabled = true

  end



  config.vm.synced_folder ".", "/vagrant", type: "nfs"
  config.bindfs.bind_folder "/vagrant/srv/eos", "/srv/eos", :force_user =>"www-data"


  

  home_dir = "/home/vagrant"

  config.vm.provision :shell, :path => "bootstrap.sh", :args => home_dir
  config.vm.provision :shell, :path => "eos.sh", :args => home_dir
  
end
