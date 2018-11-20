FROM debian:8
MAINTAINER ranger@opennms.org

LABEL id=org.opennms.bamboo.base.debian

COPY *-apt.conf /etc/apt/apt.conf.d/

# Bootstrap
RUN apt-get update && \
	apt-get -y install \
	apt-transport-https \
	curl \
	software-properties-common \
	wget \
	&& apt-get clean

# Enable the OpenNMS and Java 8 repos
RUN echo "deb https://debian.opennms.org stable main" > /etc/apt/sources.list.d/opennms.list
RUN curl -k -L -o - https://debian.opennms.org/OPENNMS-GPG-KEY | apt-key add -
RUN echo "" | add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main"

# System tools
RUN apt-get update && \
	apt-get -y install \
	openssh-client \
	openssh-server \
	rsync \
	snmp \
	sudo \
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

# Java
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
RUN apt-get update && apt-get -y install oracle-java8-installer && apt-get clean

# Node.JS
RUN curl -k -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get -y install nodejs
RUN npm install -g yarn grunt
