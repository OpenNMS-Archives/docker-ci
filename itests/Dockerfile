FROM centos:7
MAINTAINER ranger@opennms.org

LABEL id=org.opennms.bamboo.integration

# Import the OpenNMS GPG key
RUN rpm --import https://yum.opennms.org/OPENNMS-GPG-KEY

# Make sure we have the EPEL repository available
RUN yum install -y epel-release deltarpm http://yum.opennms.org/repofiles/opennms-repo-develop-rhel7.noarch.rpm

RUN yum -y install  \
	ed \ 
	expect \
	git \
	java-1.7.0-openjdk-devel \
	java-1.8.0-openjdk-devel \
	maven \
	mingw32-nsis \
	openssh-clients \
	rsync \
	unzip \
	wget \
	which \
	&& yum -y clean all

COPY *.sh blacklist-files.txt /

#ARG GIT_URL=https://github.com/OpenNMS/opennms.git
#ARG GIT_HASH

ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk

ENTRYPOINT ["/docker-cmd.sh"]
