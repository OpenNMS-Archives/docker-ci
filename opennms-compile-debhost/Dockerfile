FROM opennms-base-deb

MAINTAINER ranger@opennms.org

# packages required by OpenNMS build scripts
RUN apt-get -y install perl-base perl-modules nsis ruby

COPY opennms-compile.sh /docker-entrypoint-initdb.d/99-opennms-compile.sh
