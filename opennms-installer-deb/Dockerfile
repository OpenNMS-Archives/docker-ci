FROM opennms-base-deb

MAINTAINER ranger@opennms.org

# packages required by OpenNMS build scripts
RUN apt-get -y install perl-base perl-modules

# The script used to build the source
ADD "build-opennms-installer.sh" /root/build-opennms-installer.sh
ENTRYPOINT /root/build-opennms-installer.sh
