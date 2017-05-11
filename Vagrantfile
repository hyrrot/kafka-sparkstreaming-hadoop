# -*- mode: ruby -*-
# vi: set ft=ruby :

machines = {
  "kafka" => { "count" => 3, "ip_prefix" => "10.30.3.10" }
}

# Create hosts file
File.open("provision/tmp/hosts", "wb+") do |f|
  machines.each_pair do |hostname_prefix, host_config|
    (1..host_config['count']).each do |i|
      f.puts "#{host_config['ip_prefix']}#{i+1} #{hostname_prefix}#{i}"
    end
  end
end


Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  # Common provisioning script
  # config.vm.provision "shell", path: "scripts/common_provision.sh"

  machines.each_pair do |hostname_prefix, host_config|
    (1..host_config['count']).each do |i|
      config.vm.define "#{hostname_prefix}#{i}" do |s|
        s.vm.provider :virtualbox do |v|
          v.customize ["modifyvm", :id, "--cpuexecutioncap", "20", "--ioapic", "on"]
          v.customize ["modifyvm", :id, "--memory", "768"]
          v.customize ["modifyvm", :id, "--cpus", "2"]
        end
        s.vm.hostname = "#{hostname_prefix}#{i}"
        s.vm.network "private_network", ip: "#{host_config['ip_prefix']}#{i+1}", netmask: "255.255.255.0", virtualbox__intnet: "my-network", drop_nat_interface_default_route: true
        s.vm.provision "shell", inline: "cat /vagrant/provision/tmp/hosts >> /etc/hosts"
        s.vm.provision "shell", path: "provision/init_root.sh"
        s.vm.provision "shell", path: "provision/init_vagrant.sh", privileged: false
        s.vm.provision "shell", path: "provision/#{hostname_prefix}/init_root.sh", args: i.to_s
        s.vm.provision "shell", path: "provision/#{hostname_prefix}/init_vagrant.sh", args: i.to_s, privileged: false
      end
    end
  end  
end
