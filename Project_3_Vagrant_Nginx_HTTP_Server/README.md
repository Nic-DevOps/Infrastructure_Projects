

If you omit the config.vm.provider block entirely, Vagrant (via VirtualBox) typically uses:

Resource	Default Value
CPU	1 core
Memory (RAM)	512 MB (sometimes up to 1024 MB depending on the base box)


Vagrant automatically shares your project folder into the VM at /vagrant
So in the provision script it will check for the custom html page and replace the default nginx html page. 