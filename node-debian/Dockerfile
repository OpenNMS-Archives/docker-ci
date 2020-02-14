FROM opennmsbamboo/base-debian
MAINTAINER ranger@opennms.org

LABEL id=org.opennms.bamboo.node.debian

# Node.JS
RUN curl -k -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get -y install nodejs
RUN npm install -g yarn grunt
