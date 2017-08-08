FROM opennmsbamboo/base-centos
MAINTAINER ranger@opennms.org

LABEL id=org.opennms.bamboo.integration

# Build tools
RUN yum -y --enablerepo=epel install  \
	gcc-c++ \
	git \
	make \
	rpm-build \
	&& yum -y clean all

# OpenNMS build dependencies
RUN yum -y install \
	mingw32-nsis \
	postgresql \
	R \
	ruby \
	rubygems \
	&& yum -y clean all

COPY *.sh settings.xml blacklist-files.txt /

#ARG GIT_URL=https://github.com/OpenNMS/opennms.git
#ARG GIT_HASH

ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk

ENTRYPOINT ["/docker-cmd.sh"]
