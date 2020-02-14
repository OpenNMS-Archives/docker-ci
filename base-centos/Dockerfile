FROM centos:8
MAINTAINER ranger@opennms.org

LABEL id=org.opennms.bamboo.base.centos

# Import the OpenNMS GPG key
RUN rpm --import https://yum.opennms.org/OPENNMS-GPG-KEY

# Make sure we have the EPEL repository available
RUN yum install -y epel-release http://yum.opennms.org/repofiles/opennms-repo-stable-rhel8.noarch.rpm \
	&& yum -y --enablerepo='*' clean packages \
	&& rm -rf /var/cache/yum

# System tools
RUN yum -y install  \
	curl \
	ed \
	expect \
	git \
	net-snmp \
	openssh-clients \
	openssh-server \
	postgresql \
	rsync \
	sudo \
	unzip \
	wget \
	which \
	&& yum -y --enablerepo='*' clean packages \
	&& rm -rf /var/cache/yum

# Java dependencies
RUN yum -y install \
	java-1.8.0-openjdk-devel \
	maven \
	http://mirror.internal.opennms.com/yum/stable/common/jdk/x64/jdk-8u181-linux-x64.rpm \
	&& yum -y --enablerepo='*' clean packages \
	&& rm -rf /var/cache/yum
