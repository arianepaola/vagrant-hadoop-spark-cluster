# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'ipaddr'

Vagrant.require_version ">= 1.4.3"
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    numNodes = 3
    masterMem = 2048
    workerMem = 1024

startIpAddress = IPAddr.new "10.211.55.10"
    nodeIpAddresses = []

    numNodes.times do |i|
        ipAddress = startIpAddress.to_i + i
        nodeIp = [24, 16, 8, 0].collect {|k| (ipAddress >> k) & 255}.join('.')

        nodeIpAddresses << nodeIp
    end

	# application should be either "flink" or "spark"
	app = "spark"
    r = numNodes..1

    numNodes.downto(1).each do |i|
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

            node.vm.network "private_network", ip: nodeIpAddresses[i-1]

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
                node.vm.provision "shell" do |s|
                    s.path = "scripts/setup-spark-slaves.sh"
                    s.args = "-s 2 -t #{numNodes}"
                end
            end


            # Initialize the Hadoop cluster, start Hadoop daemons
            if i == 1
                node.vm.provision "shell",
                    inline: "$HADOOP_PREFIX/bin/hdfs namenode -format myhadoop",
                    privileged: true
                node.vm.provision "shell",
                    inline: "$HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode",
                    privileged: true
                node.vm.provision "shell",
                    inline: "$HADOOP_PREFIX/sbin/hadoop-daemons.sh --config $HADOOP_CONF_DIR --script hdfs start datanode",
                    privileged: true
                # Start Spark in Standalone Mode
                node.vm.provision "shell",
                    inline: "$SPARK_HOME/sbin/start-all.sh",
                    privileged: true
            end
            # Start YARN
            if i == 2
                node.vm.provision "shell",
                    inline: "$HADOOP_YARN_HOME/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start resourcemanager",
                    privileged: true
                node.vm.provision "shell",
                    inline: "$HADOOP_YARN_HOME/sbin/yarn-daemons.sh --config $HADOOP_CONF_DIR start nodemanager",
                    privileged: true
                node.vm.provision "shell",
                    inline: "$HADOOP_YARN_HOME/sbin/yarn-daemon.sh start proxyserver --config $HADOOP_CONF_DIR",
                    privileged: true
                node.vm.provision "shell",
                    inline: "$HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh start historyserver --config $HADOOP_CONF_DIR",
                    privileged: true
            end


        end
    end
end
