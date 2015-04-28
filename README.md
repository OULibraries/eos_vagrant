# How to EOS


## Requires

Currently requires:

* private checkout of eos code
* vagrant plugins: landrush and bindfs


## Running


* clone eos code to .../srv/eos
* run "vagrant up"

This will run, then fail.

* `vagrant ssh`
* `sudo bash /vagrant/bootstrap.sh` to complete initial package install. Will require manually doing the grub thingy that is breaking the install
* `sudo bash /vagrant/eosh.sh` to complete the app install.

Then you should have a running version of eos 
