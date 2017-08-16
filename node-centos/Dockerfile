FROM opennmsbamboo/base-centos
MAINTAINER ranger@opennms.org

LABEL id=org.opennms.bamboo.node.centos

# Build tools
RUN yum -y --enablerepo=epel install  \
	gcc-c++ \
	git \
	make \
	rpm-build \
	&& yum -y --enablerepo='*' clean packages

# Node.JS
RUN curl --silent --location https://rpm.nodesource.com/setup_8.x | bash -
RUN yum -y install nodejs \
	&& yum -y --enablerepo='*' clean packages
RUN npm install -g yarn grunt
