FROM opennmsbamboo/base-centos
MAINTAINER ranger@opennms.org

LABEL id=org.opennms.bamboo.node.centos

# Build tools
RUN yum -y --enablerepo=epel install  \
	gcc-c++ \
	git \
	make \
	rpm-build \
	&& yum -y --enablerepo='*' clean packages \
	&& rm -rf /var/cache/yum

# Node.JS
RUN curl -k --silent --location https://rpm.nodesource.com/setup_10.x | bash -
RUN yum -y install nodejs \
	&& yum -y --enablerepo='*' clean packages \
	&& rm -rf /var/cache/yum
RUN npm install -g yarn grunt
