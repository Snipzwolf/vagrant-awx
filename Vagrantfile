# -*- mode: ruby -*-
# vi: set ft=ruby :

shell_env_vars = {
  ansible_version: "2.4.6",
  awx_version: "4.0.0",
  dockerpy_version: "4.0.1",
  dockercompose_version: "1.24.0",
  awx_cli_version: "3.3.4",
  node_repo: "https://deb.nodesource.com/setup_10.x"
}

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-18.04"

  config.vm.network "forwarded_port", guest: 80, host_ip: "127.0.0.1", host: 8080
  config.vm.network "forwarded_port", guest: 22, host_ip: "127.0.0.1", host: 2251

  config.vm.provider "virtualbox" do |vb|
    vb.name = "vagrant-awx"

    vb.customize ["modifyvm", :id, "--memory", 4096]
    vb.customize ["modifyvm", :id, "--cpus", 3]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  if(File.directory?("./.private"))
    config.vm.synced_folder "./.private", "/home/vagrant/private-sync"
  end

  if(File.file?("./.private/pre-provision.sh"))
    config.vm.provision :shell, :path => "./.private/pre-provision.sh", :env => shell_env_vars
  end

  config.vm.provision :shell, :path => "provision.sh", :env => shell_env_vars

  if(File.file?("./.private/post-provision.sh"))
    config.vm.provision :shell, :path => "./.private/post-provision.sh", :env => shell_env_vars
  end
end
