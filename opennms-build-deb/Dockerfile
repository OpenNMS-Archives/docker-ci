FROM opennms-base-deb

MAINTAINER ranger@opennms.org

# packages required by OpenNMS build scripts
RUN apt-get -y install perl-base perl-modules

ENTRYPOINT /root/opennms-build.sh
