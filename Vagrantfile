# -*- mode: ruby -*-
# vi: set ft=ruby :

shell_env_vars = {
  ansible_version: "2.4.6",
  awx_version: "4.0.0",
  node_repo: "https://deb.nodesource.com/setup_10.x"
}

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-18.04"

  config.vm.network "forwarded_port", guest: 22, host_ip: "127.0.0.1", host: 2221
  config.vm.network "forwarded_port", guest: 80, host_ip: "127.0.0.1", host: 8080

  config.vm.provider "virtualbox" do |vb|
    vb.name = "vagrant-awx"

    vb.customize ["modifyvm", :id, "--memory", 2048]
    vb.customize ["modifyvm", :id, "--cpus", 4]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.vm.provision :shell, :path => "provision.sh", :env => shell_env_vars
end
