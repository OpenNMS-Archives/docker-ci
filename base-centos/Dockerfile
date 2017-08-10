FROM centos:7
MAINTAINER ranger@opennms.org

LABEL id=org.opennms.bamboo.base.centos

# Import the OpenNMS GPG key
RUN rpm --import https://yum.opennms.org/OPENNMS-GPG-KEY

# Make sure we have the EPEL repository available
RUN yum install -y epel-release deltarpm http://yum.opennms.org/repofiles/opennms-repo-develop-rhel7.noarch.rpm

# System tools
RUN yum -y install  \
	curl \
	ed \
	expect \
	git \
	openssh-clients \
	openssh-server \
	postgresql \
	rsync \
	sudo \
	unzip \
	wget \
	which \
	&& yum -y clean all

# Java dependencies
RUN yum -y install \
	java-1.7.0-openjdk-devel \
	java-1.8.0-openjdk-devel \
	maven \
	&& yum -y clean all
