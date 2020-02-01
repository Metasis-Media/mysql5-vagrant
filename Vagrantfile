# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.network :forwarded_port, guest: 3306, host: 3306
  config.vm.provision :shell, :path => "provision.sh"
  config.vm.synced_folder ".", "/vagrant", :mount_options => ["dmode=777", "fmode=666"]
  config.vm.provider "virtualbox" do |v|
    v.name = "mysql57"
    v.memory = 2048
    v.cpus = 2
  end
  config.vm.network "private_network", ip: "10.20.30.40"
end
