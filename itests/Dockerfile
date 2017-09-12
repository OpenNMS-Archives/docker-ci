FROM opennmsbamboo/build-centos
MAINTAINER ranger@opennms.org

LABEL id=org.opennms.bamboo.integration

COPY *.sh settings.xml blacklist-files.txt /

#ARG GIT_URL=https://github.com/OpenNMS/opennms.git
#ARG GIT_HASH
ENTRYPOINT ["/docker-cmd.sh"]
