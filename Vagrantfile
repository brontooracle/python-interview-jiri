
Vagrant.configure(2) do |config|
  config.ssh.insert_key = false
  config.vm.provision "file", source: "~/.vagrant.d/insecure_private_key", destination: "~/.ssh/id_rsa"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "256"
    vb.cpus = 1
  end

  ######### BASE VM #########
  # We use this to build a base box, package it, and quickly set up the rest of the VMs

  config.vm.define "base", primary: false do |base|
    base.vm.box = "ol76"
    base.vm.box_url = "https://yum.oracle.com/boxes/oraclelinux/ol76/ol76.box"
    base.vm.provision "shell", path: "devel/base.sh"
  end


  ######### VMs necessary for the interview #########

  config.vm.define "manager", primary: true do |manager|
      manager.vm.box = "base"
      manager.vm.box_url = "file://base.box"
      manager.vm.hostname = "manager"
      manager.vm.network "private_network", ip: "172.28.46.2"
      manager.vm.network "forwarded_port", guest: 5000, host: 5000
      manager.vm.network "forwarded_port", guest: 22, host: 6000
      manager.vm.network "forwarded_port", guest: 8000, host: 8000
      manager.vm.provision "shell", path: "devel/manager.sh"
  end

  config.vm.define "db1", primary: false do |db1|
    db1.vm.box = "base"
    db1.vm.box_url = "file://base.box"
    db1.vm.hostname = "mysql-01-prod"
    db1.vm.network "private_network", ip: "172.28.46.3"
    db1.vm.provision "shell", path: "devel/db/mysql-01-prod.sh"
  end

  config.vm.define "db2", primary: false do |db2|
    db2.vm.box = "base"
    db2.vm.box_url = "file://package.box"
    db2.vm.hostname = "mysql-02-prod"
    db2.vm.network "private_network", ip: "172.28.46.4"
    db2.vm.provision "shell", path: "devel/db/mysql-02-prod.sh"
  end

  config.vm.define "db3", primary: false do |db3|
    db3.vm.box = "base"
    db3.vm.box_url = "file://package.box"
    db3.vm.hostname = "mysql-03-prod"
    db3.vm.network "private_network", ip: "172.28.46.5"
    db3.vm.provision "shell", path: "devel/db/mysql-03-prod.sh"
  end

  config.vm.define "db4", primary: false do |db4|
    db4.vm.box = "base"
    db4.vm.box_url = "file://package.box"
    db4.vm.hostname = "mysql-04-prod"
    db4.vm.network "private_network", ip: "172.28.46.6"
    db4.vm.provision "shell", path: "devel/db/mysql-04-prod.sh"
  end

end
