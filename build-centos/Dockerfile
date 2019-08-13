FROM opennmsbamboo/base-centos
MAINTAINER ranger@opennms.org

LABEL id=org.opennms.bamboo.build.centos

# Build tools
RUN yum -y --enablerepo=epel install  \
	gcc-c++ \
	git \
	make \
	rpm-build \
	&& yum -y --enablerepo='*' clean packages \
	&& rm -rf /var/cache/yum

# OpenNMS build dependencies
RUN yum -y install \
	mingw32-nsis \
	postgresql \
	R \
	rrdtool \
	ruby \
	ruby-devel \
	rubygems \
	&& yum -y --enablerepo='*' clean packages \
	&& rm -rf /var/cache/yum

RUN gem install rb-inotify -v 0.9.10
RUN gem install sass

ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk
