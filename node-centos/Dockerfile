FROM centos:7
MAINTAINER ranger@opennms.org

LABEL id=org.opennms.bamboo.node.centos

# Import the OpenNMS GPG key
RUN rpm --import https://yum.opennms.org/OPENNMS-GPG-KEY

# Make sure we have the EPEL repository available
RUN yum install -y epel-release deltarpm http://yum.opennms.org/repofiles/opennms-repo-develop-rhel7.noarch.rpm

RUN yum -y --enablerepo=epel install  \
	gcc-c++ \
	git \
	make \
	nodejs \
	openssh-clients \
	rpm-build \
	rsync \
	unzip \
	wget \
	which \
	&& yum -y clean all

RUN npm install -g yarn grunt
