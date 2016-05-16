# -*- mode: ruby -*-
# vi: set ft=ruby :

require "vagrant"

if Vagrant::VERSION < "1.2.1"
  raise "The Omnibus Build Lab is only compatible with Vagrant 1.2.1+"
end

host_project_path = File.expand_path("..", __FILE__)
guest_project_path = "/home/vagrant/#{File.basename(host_project_path)}"
project_name = "contegix-salt-minion"

Vagrant.configure("2") do |config|

  config.vm.hostname = "#{project_name}.build.contegix.com"

  config.vm.define 'centos-5.11_64' do |c|
    c.berkshelf.berksfile_path = "./Berksfile"
    c.vm.box = "bento/centos-5.11"
    c.vm.provision "init", type: "shell", preserve_order: true, inline: "wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-5.noarch.rpm && sudo rpm -Uvh epel-release-latest-5.noarch.rpm; true"
  end

  config.vm.define 'centos-5.11_32' do |c|
    c.berkshelf.berksfile_path = "./Berksfile"
    c.vm.box = "bento/centos-5.11-i386"
    # Ensure that EPEL is installed for git
    c.vm.provision "init", type: "shell", preserve_order: true, inline: "wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-5.noarch.rpm && sudo rpm -Uvh epel-release-latest-5.noarch.rpm; true"
  end

  config.vm.define 'centos-6.7_64' do |c|
    c.berkshelf.berksfile_path = "./Berksfile"
    c.vm.box = "bento/centos-6.7"
  end

  config.vm.define 'centos-6.7_32' do |c|
    c.berkshelf.berksfile_path = "./Berksfile"
    c.vm.box = "bento/centos-6.7-i386"
  end

  config.vm.define 'centos-7.1_64' do |c|
    c.berkshelf.berksfile_path = "./Berksfile"
    c.vm.box = "bento/centos-7.1"
    # Install fakeroot for el7 from EPEL
    c.vm.provision "init", type: "shell", preserve_order: true, inline: "sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-5.noarch.rpm && sudo yum install -y fakeroot; true"
  end

  config.vm.define 'ubuntu-14.04_64' do |c|
    c.berkshelf.berksfile_path = "./Berksfile"
    c.vm.box = "bento/ubuntu-14.04"
  end

  config.vm.define 'debian-6.0_64' do |c|
    c.berkshelf.berksfile_path = "./Berksfile"
    c.vm.box = "bento/debian-6.0.10"
  end

  config.vm.provider :virtualbox do |vb|
    # Give enough horsepower to build without taking all day.
    vb.customize [
      "modifyvm", :id,
      "--memory", "2048",
      "--cpus", "2"
    ]
    vb.customize [
      "modifyvm", :id,
      "--natdnshostresolver1", "on"
    ]
    vb.customize [
      "modifyvm", :id,
      "--natdnsproxy1", "on"
    ]
  end

  # Ensure a recent version of the Chef Omnibus packages are installed
  config.omnibus.chef_version = :latest

  # Enable the berkshelf-vagrant plugin
  config.berkshelf.enabled = true
  # The path to the Berksfile to use with Vagrant Berkshelf
  config.berkshelf.berksfile_path = "./Berksfile"

  config.ssh.forward_agent = true

  host_project_path = File.expand_path("..", __FILE__)
  guest_project_path = "/home/vagrant/#{File.basename(host_project_path)}"

  config.vm.synced_folder host_project_path, guest_project_path

  config.vm.provision "init", type: "shell", inline: "echo 'No init tasks. Continuing.'"

  # prepare VM to be an Omnibus builder
  config.vm.provision :chef_solo do |chef|
    # chef.version = "12.8.3"

    chef.cookbooks_path = "cookbooks"

    chef.json = {
      "omnibus" => {
        "build_user" => "vagrant",
        "build_dir" => guest_project_path,
        "install_dir" => "/opt/contegix/salt"
      }
    }

    chef.run_list = [
      "recipe[omnibus::default]"
    ]
  end

  config.vm.provision :shell, :inline => <<-OMNIBUS_BUILD
    export PATH=/usr/local/bin:$PATH
    cd #{guest_project_path}
    su vagrant -c ". /home/vagrant/load-omnibus-toolchain.sh; bundle install --binstubs"
    su vagrant -c ". /home/vagrant/load-omnibus-toolchain.sh; omnibus build #{project_name}"
  OMNIBUS_BUILD
end
