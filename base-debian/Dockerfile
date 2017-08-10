FROM debian:8
MAINTAINER ranger@opennms.org

LABEL id=org.opennms.bamboo.base.debian

# Bootstrap
RUN apt-get update && \
	apt-get -y install \
	apt-transport-https \
	curl \
	wget \
	&& apt-get clean

# Enable the OpenNMS repo
RUN echo "deb https://debian.opennms.org stable main" > /etc/apt/sources.list.d/opennms.list
RUN curl -L -o - https://debian.opennms.org/OPENNMS-GPG-KEY | apt-key add -

# System tools
RUN apt-get update && \
	apt-get -y install \
	openssh-client \
	openssh-server \
	rsync \
	unzip \
	&& apt-get clean

# Build tools
RUN apt-get update && \
	apt-get -y install \
	devscripts \
	dpkg-dev \
	gcc \
	git \
	make \
	&& apt-get clean

# Node.JS
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get -y install nodejs
RUN npm install -g yarn grunt
