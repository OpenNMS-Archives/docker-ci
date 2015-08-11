FROM debian:oldstable

MAINTAINER ranger@opennms.org

# Set up the APT environment for OpenNMS
RUN apt-get -y update && apt-get -y install apt-transport-https wget gnupg
RUN wget --quiet -O - http://debian.opennms.org/OPENNMS-GPG-KEY | apt-key add -
RUN echo "deb http://debian.opennms.org stable main" > /etc/apt/sources.list.d/opennms.list

# Install the Oracle JDK(s)
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu wily main" > /etc/apt/sources.list.d/webupd8team-java.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN apt-get -y update && apt-get -y install debconf
RUN echo "oracle-java7-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections
RUN apt-get -y install oracle-java7-installer oracle-java8-installer

# build directory
ENV DATADIR /data
VOLUME "${DATADIR}"

RUN mkdir -p /docker-entrypoint-initdb.d

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
