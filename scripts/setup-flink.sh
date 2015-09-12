#!/bin/bash
source "/vagrant/scripts/common.sh"

function installLocalFlink {
	echo "install flink from local file"
	FILE=/vagrant/resources/$FLINK_ARCHIVE
	tar -xzf $FILE -C /usr/local
}

function installRemoteFlink {
	echo "install flink from remote file"
	curl -o /vagrant/resources/$FLINK_ARCHIVE -O -L $FLINK_MIRROR_DOWNLOAD
	tar -xzf /vagrant/resources/$FLINK_ARCHIVE -C /usr/local
}

function setupFlink {
	echo "setup flink"
	#cp -f /vagrant/resources/flink/slaves /usr/local/flink/conf
}

function setupEnvVars {
	echo "creating flink environment variables"
	#cp -f $FLINK_RES_DIR/flink.sh /etc/profile.d/flink.sh
}

function installFlink {
	if resourceExists $FLINK_ARCHIVE; then
		installLocalFlink
	else
		installRemoteFlink
	fi
	ln -s /usr/local/$FLINK_VERSION /usr/local/flink
}

echo "setup flink"

installFlink
setupFlink
setupEnvVars
