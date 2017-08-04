FROM opennmsbamboo/base-debian
MAINTAINER ranger@opennms.org

LABEL id=org.opennms.bamboo.node.debian

# Node.JS
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get -y install nodejs
RUN npm install -g yarn grunt
