OpenNMS Docker Continuous Integration
=====================================

This project contains a set of docker containers that can be used for
building and testing OpenNMS.

About the Docker Containers
===========================

opennms-base-deb
----------------

A Debian "base" container that sets up APT to access the webupd8 and
OpenNMS repositories, as well as install JDKs.

opennms-base-rpm
----------------

A CentOS "base" container that sets up Yum to access the OpenNMS Yum
repository, as well as install JDKs.

Customizing the Docker Containers
=================================

The /data Volume
----------------

The opennms-base-\* containers are configured to have a volume called
_/data_ that all building and running happens in.

The /docker-entrypoint-initdb.d Directory
-----------------------------------------

Similar to the PostgreSQL container, the opennms-base-\* containers have
an _ENTRYPOINT_ of "/root/docker-entrypoint.sh"
by default, which in turn will run any scripts in the
_/docker-entrypoint-initdb.d_ directory.

Arguments passed to the "_docker run_" command will be passed through
to each of the scripts run from _/docker-entrypoint-initdb.d_.
