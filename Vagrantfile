# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

$manager_script = <<SCRIPT
	echo Swarm - Init...
	docker swarm init --listen-addr 192.168.0.10:2377 --advertise-addr 192.168.0.10:2377
	
	echo Swarm - swarm join-token --quiet worker > /vagrant/worker_token...
	docker swarm join-token --quiet worker > /vagrant/worker_token
SCRIPT

#	echo Swarm - docker run -ti -d -p 5000:5000 -e HOST=localhost -e PORT=5000 -v /var/run/docker.sock:/var/run/docker.sock dockersamples/visualizer
#	docker run -ti -d -p 5000:5000 -e HOST=localhost -e PORT=5000 -v /var/run/docker.sock:/var/run/docker.sock dockersamples/visualizer


$worker_script = <<SCRIPT
	echo Swarm Join...
	docker swarm join --token $(cat /vagrant/worker_token) 192.168.0.10:2377
SCRIPT

Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.
  unless Vagrant.has_plugin?("vagrant-proxyconf")
  	raise 'vagrant-proxyconf is not installed!'
  end
    
  unless Vagrant.has_plugin?("vagrant-vbguest")
  	raise 'vagrant-vbguest is not installed!'
  end

  config.vm.define :dockerSwarmMaster do | dcSM_Config |
	if Vagrant.has_plugin?("vagrant-proxyconf")
		dcSM_Config.proxy.http     = "http://SP32356:Fis072017@172.30.10.103:80/"
		dcSM_Config.proxy.https    = "http://SP32356:Fis072017@172.30.10.103:80/"
		dcSM_Config.proxy.no_proxy = "localhost,127.0.0.1"
	end 
  
	dcSM_Config.vm.box = "centos/7"
	dcSM_Config.vm.hostname = "swarmMaster"
	dcSM_Config.vm.network :private_network, ip: "192.168.0.10"
	dcSM_Config.vm.network "forwarded_port", guest: 5000, host: 5000
	dcSM_Config.vm.network "forwarded_port", guest: 8080, host: 8080
	dcSM_Config.vm.box_check_update = true
	dcSM_Config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
	dcSM_Config.vm.provider "virtualbox" do |vb| 
											vb.memory = "1024"
											vb.cpus = 2
										end
	dcSM_Config.vm.provision :shell, path: "bootstrap.sh"
	dcSM_Config.vm.provision "shell", inline: $manager_script, privileged: true	
	
	end
 
   # create some web servers
  # https://docs.vagrantup.com/v2/vagrantfile/tips.html
  (1..2).each do |i|
    config.vm.define "dockerWorker#{i}" do |worker|
		if Vagrant.has_plugin?("vagrant-proxyconf")
			worker.proxy.http     = "http://SP32356:Fis072017@172.30.10.103:80/"
			worker.proxy.https    = "http://SP32356:Fis072017@172.30.10.103:80/"
			worker.proxy.no_proxy = "localhost,127.0.0.1"
		end 	
	
        worker.vm.box = "centos/7"
        worker.vm.hostname = "dockerWorker#{i}"
        worker.vm.network :private_network, ip: "192.168.0.2#{i}"
        worker.vm.network "forwarded_port", guest: 80, host: "868#{i}"
		worker.vm.box_check_update = true
		worker.vm.synced_folder ".", "/vagrant", type: "virtualbox"

        worker.vm.provider "virtualbox" do |vb|
          vb.memory = "256"
        end
		
		worker.vm.provision :shell, path: "bootstrap.sh"
		worker.vm.provision "shell", inline: $worker_script, privileged: true
		
    end
  end
 
 
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
