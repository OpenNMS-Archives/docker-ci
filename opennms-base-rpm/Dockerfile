FROM centos:6

MAINTAINER ranger@opennms.org

RUN yum -y install wget

# Set up the YUM environment for OpenNMS
RUN yum -y install http://yum.opennms.org/repofiles/opennms-repo-stable-rhel6.noarch.rpm
RUN wget --quiet https://copr.fedoraproject.org/coprs/opennms/opennms/repo/epel-6/opennms-opennms-epel-6.repo -O /etc/yum.repos.d/copr-opennms-epel-6.repo

# Install the JDK(s)
RUN yum -y install java-1.7.0-openjdk

env JDK8_VERSION 8u51
RUN wget --quiet --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
	http://download.oracle.com/otn-pub/java/jdk/${JDK8_VERSION}-b16/jdk-${JDK8_VERSION}-linux-x64.rpm && \
	yum -y install jdk-${JDK8_VERSION}-linux-x64.rpm && \
	rm -f jdk-*.rpm

# build directory
ENV DATADIR /data
VOLUME "${DATADIR}"

RUN mkdir -p /docker-entrypoint-initdb.d
COPY init.d/* /docker-entrypoint-initdb.d/

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
