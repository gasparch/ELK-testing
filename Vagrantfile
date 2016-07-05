# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
	config.vm.box = "ubuntu/trusty64"

	if Vagrant.has_plugin?("vagrant-cachier")
		# Configure cached packages to be shared between instances of the same base box.
		# More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
		config.cache.scope = :box
	end

	config.vm.provider "virtualbox" do |vb|
		# Display the VirtualBox GUI when booting the machine
		# vb.gui = true

		# vb.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
		vb.cpus = 1

		# Customize the amount of memory on the VM:
		vb.memory = "1024"

		vb.linked_clone = true if Vagrant::VERSION =~ /^1.8/
	end

	config.vm.define "wallabag", autostart: false do |instance|
		instance.vm.hostname = "wallabag.example.com"
		# run all scripts together in single command, so vagrant-cachier will run one time only
		instance.vm.provision :shell, :path => "all_shell_tasks_together.sh", :args => "wallabag"
		instance.vm.network :private_network, ip: "192.168.34.8"
	end

	config.vm.define "kibana", autostart: false do |instance|
		instance.vm.hostname = "kibana.example.com"
		# run all scripts together in single command, so vagrant-cachier will run one time only
		instance.vm.provision :shell, :path => "all_shell_tasks_together.sh", :args => "kibana"
		instance.vm.network :private_network, ip: "192.168.34.9"
	end

	config.vm.define "grafana", autostart: false do |instance|
		instance.vm.hostname = "grafana.example.com"
		# run all scripts together in single command, so vagrant-cachier will run one time only
		instance.vm.provision :shell, :path => "all_shell_tasks_together.sh grafana"
		instance.vm.network :private_network, ip: "192.168.34.10"
	end
end
