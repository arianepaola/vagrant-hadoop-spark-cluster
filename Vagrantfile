Vagrant.require_version ">= 1.4.3"
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    numNodes = 4
    masterMem = 2048
    workerMem = 2048
	# application should be either "flink" or "spark"
	app = "flink"
    r = numNodes..1
    (r.first).downto(r.last).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.box = "centos65"
            node.vm.box_url = "http://files.brianbirkinbine.com/vagrant-centos-65-i386-minimal.box"
            node.vm.provider "virtualbox" do |v|
              v.name = "node#{i}"
              if i > 1
                  v.customize ["modifyvm", :id, "--memory", "#{workerMem}"]
              else
                  v.customize ["modifyvm", :id, "--memory", "#{masterMem}"]
              end
            end
            if i < 10
                node.vm.network :private_network, ip: "10.211.55.10#{i}"
            else
                node.vm.network :private_network, ip: "10.211.55.1#{i}"
            end
            node.vm.hostname = "node#{i}"
            node.vm.provision "shell", path: "scripts/setup-centos.sh"
            node.vm.provision "shell" do |s|
                s.path = "scripts/setup-centos-hosts.sh"
                s.args = "-t #{numNodes}"
            end
            if i == 1
                node.vm.provision "shell" do |s|
                    s.path = "scripts/setup-centos-ssh.sh"
                    s.args = "-s 2 -t #{numNodes}"
                end
            end
            node.vm.provision "shell", path: "scripts/setup-java.sh"
            node.vm.provision "shell", path: "scripts/setup-hadoop.sh"
            node.vm.provision "shell" do |s|
                s.path = "scripts/setup-hadoop-slaves.sh"
                s.args = "-s 2 -t #{numNodes}"
            end
            if app == "flink"
                node.vm.provision "shell", path: "scripts/setup-flink.sh"
            elsif app == "spark"
                node.vm.provision "shell", path: "scripts/setup-spark.sh"
                # for spark standalone only, useless with YARN
                #node.vm.provision "shell" do |s|
                #    s.path = "scripts/setup-spark-slaves.sh"
                #    s.args = "-s 2 -t #{numNodes}"
                #end
            end
        end
    end
end
