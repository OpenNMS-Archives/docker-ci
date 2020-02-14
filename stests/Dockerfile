FROM opennmsbamboo/base-centos
MAINTAINER ranger@opennms.org

LABEL id=org.opennms.bamboo.smoke

# Build tools
RUN yum -y --enablerepo=epel --enablerepo=PowerTools install  \
	gcc-c++ \
	git \
	make \
	rpm-build \
	&& yum -y --enablerepo='*' clean packages \
	&& rm -rf /var/cache/yum

# OpenNMS build dependencies
RUN yum -y --enablerepo=PowerTools install \
	mingw32-nsis \
	postgresql \
	R \
	ruby \
	rubygems \
	&& yum -y --enablerepo='*' clean packages \
	&& rm -rf /var/cache/yum

# OpenNMS test dependencies
RUN yum -y --enablerepo=PowerTools install \
	jicmp \
	jicmp6 \
	&& yum -y --enablerepo='*' clean packages \
	&& rm -rf /var/cache/yum

COPY *.sh settings.xml /

#ARG GIT_URL=https://github.com/OpenNMS/opennms.git
#ARG GIT_HASH

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk

ENTRYPOINT ["/docker-cmd.sh"]
