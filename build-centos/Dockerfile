FROM opennmsbamboo/base-centos
MAINTAINER ranger@opennms.org

LABEL id=org.opennms.bamboo.build.centos

RUN curl -L -o /etc/yum.repos.d/mock.repo https://copr.fedorainfracloud.org/coprs/g/mock/mock-stable/repo/epel-7/group_mock-mock-stable-epel-7.repo

# Build tools
RUN yum -y --enablerepo=epel install  \
	gcc-c++ \
	git \
	make \
	mock \
	rpm-build \
	yum-utils \
	&& yum -y --enablerepo='*' clean packages \
	&& rm -rf /var/cache/yum
RUN adduser -r -u 1000 -g mock mock

# OpenNMS build dependencies
RUN yum -y \
	--enablerepo='epel' \
	--enablerepo='opennms-repo-stable-common' \
	--enablerepo='opennms-repo-stable-rhel7' \
	install \
		jicmp \
		jicmp6 \
		jrrd \
		jrrd2 \
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
