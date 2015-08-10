FROM debian:oldstable

MAINTAINER ranger@opennms.org

# Set up the APT environment for OpenNMS
RUN apt-get -y update && apt-get -y install apt-transport-https wget gnupg
RUN wget -O - http://debian.opennms.org/OPENNMS-GPG-KEY | apt-key add -
RUN echo "deb http://debian.opennms.org stable main" > /etc/apt/sources.list.d/opennms.list

# Install the Oracle JDK(s)
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu wily main" > /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN apt-get -y update && apt-get -y install debconf
RUN echo "oracle-java6-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections
RUN echo "oracle-java7-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections
RUN echo "oracle-java9-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections
RUN apt-get -y install oracle-java7-installer oracle-java8-installer

# packages required by OpenNMS build scripts
RUN apt-get -y install perl-base perl-modules

# build directory
WORKDIR /data
VOLUME "${WORKDIR}"

# The script used to build the source
ADD "build-opennms.sh" "${WORKDIR}/build-opennms.sh"
ENTRYPOINT "${WORKDIR}/build-opennms.sh"
