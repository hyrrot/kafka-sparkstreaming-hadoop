# -*- mode: ruby -*-
# vi: set ft=ruby :

machines = {
  "kafka-zk" => {
    "count" => 3,
    "ip_prefix" => "10.30.3.10",
    "cpu_execution_cap" => 10,
    "cores" => 2,
    "memory" => 512,
    "port_forwarding" => [2181]
  },
  "kafka-br" => {
    "count" => 3,
    "ip_prefix" => "10.30.3.11",
    "cpu_execution_cap" => 10,
    "cores" => 2,
    "memory" => 1024,
    "port_forwarding" => [9092]
 },
 "spark-master" => {
   "count" => 1,
   "ip_prefix" => "10.30.3.20",
   "cpu_execution_cap" => 10,
   "cores" => 2,
   "memory" => 512,
   "port_forwarding" => [8080, 7077]
 }
# "spark-slave" => {
#   "count" => 3,
#   "ip_prefix" => "10.30.3.21",
#   "cpu_execution_cap" => 40,
#   "cores" => 2,
#   "memory" => 2048,
#   "port_forwarding" => []
# }
}

# Create hosts file
File.open("provision/tmp/hosts", "wb+") do |f|
  machines.each_pair do |hostname_prefix, host_config|
    (1..host_config['count']).each do |i|
      f.puts "#{host_config['ip_prefix']}#{i+1} #{hostname_prefix}#{i}"
    end
  end
end

# Download prerequisites
system("#{File.dirname(__FILE__)}/provision/download_prereq.sh")

Vagrant.configure("2") do |config|
  config.vm.box = "maier/centos-6.3-x86_64"

  # Common provisioning script
  # config.vm.provision "shell", path: "scripts/common_provision.sh"

  machines.each_pair do |hostname_prefix, host_config|
    (1..host_config['count']).each do |i|
      config.vm.define "#{hostname_prefix}#{i}" do |s|
        s.vm.provider :virtualbox do |v|
          v.customize ["modifyvm", :id, "--cpuexecutioncap", host_config['cpu_execution_cap'], "--ioapic", "on"]
          v.customize ["modifyvm", :id, "--memory", host_config['memory']]
          v.customize ["modifyvm", :id, "--cpus", host_config['cores']]
        end
        s.vm.hostname = "#{hostname_prefix}#{i}"
        s.vm.network "private_network", ip: "#{host_config['ip_prefix']}#{i+1}", netmask: "255.255.255.0", virtualbox__intnet: "my-network", drop_nat_interface_default_route: true
        host_config['port_forwarding'].each do |port|
            s.vm.network "forwarded_port", guest: port, host: port + (i-1), auto_correct: true
        end
        s.vm.provision "shell", inline: "cat /vagrant/provision/tmp/hosts >> /etc/hosts"
        s.vm.provision "shell", path: "provision/init_root.sh"
        s.vm.provision "shell", path: "provision/init_vagrant.sh", privileged: false
        s.vm.provision "shell", path: "provision/#{hostname_prefix}/init_root.sh", args: i.to_s
        s.vm.provision "shell", path: "provision/#{hostname_prefix}/init_vagrant.sh", args: [i.to_s, host_config['count'].to_s], privileged: false
      end
    end
  end
end
