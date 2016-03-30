# How to EOS


## Requires

Currently requires:

* private checkout of eos code
* [virtualbox](https://www.virtualbox.org/)
* [vagrant](http://vagrantup.com/) 
* vagrant plugins: [landrush](https://github.com/phinze/landrush) and [bindfs](https://github.com/gael-ian/vagrant-bindfs)


## Running

To get things started do:

* `git clone https://github.com/OULibraries/eos_vagrant`
* clone eos code to `.../eos_vagrant/srv/eos`
* clone the eos code into `.../eos_vagrant/eoa-django`
* clone the eos scripts into `.../eos_vagrant/EOASkripts`
* copy the Django PostgreSQL into `.../eos_vagrant/djangodb.psql`
* run `vagrant up`

If everything worked you shold be able to:

* run `vagrant ssh` to connect to the box
* access the EOS app at http://eos.vm/

Files in `.../eos_vagrant` on the host box will be mounted at
`/vagrant` on the guest. Additionally, files in
`.../eos_vagrant/srv/eos` will be bindfs mounted `/srv/eos` with
ownership masked to `www-data`.



