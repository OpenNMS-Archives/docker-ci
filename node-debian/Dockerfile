FROM debian:8
MAINTAINER ranger@opennms.org

LABEL id=org.opennms.bamboo.node.debian

RUN apt-get update
RUN apt-get -y install \
	apt-transport-https \
	curl \
	devscripts \
	dpkg-dev \
	gcc \
	git \
	make \
	openssh-client \
	rsync \
	unzip \
	&& apt-get clean

# Enable the OpenNMS repo
RUN echo "deb https://debian.opennms.org stable main" > /etc/apt/sources.list.d/opennms.list
RUN curl -L -o - https://debian.opennms.org/OPENNMS-GPG-KEY | apt-key add -

# Enable the Node.JS repo
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get -y install \
	nodejs

RUN npm install -g yarn grunt
