FROM opennmsbamboo/base-centos
MAINTAINER ranger@opennms.org

LABEL id=org.opennms.bamboo.node.centos

# Build tools
RUN yum -y --enablerepo=epel install  \
	gcc-c++ \
	git \
	make \
	rpm-build \
	&& yum -y clean all

# Node.JS
RUN yum -y --enablerepo=epel install  \
	nodejs \
	&& yum -y clean all
RUN npm install -g yarn grunt
