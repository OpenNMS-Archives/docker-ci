#!/bin/bash -e

(docker rm $(docker ps -aq)) || :
(docker rmi $(docker images --filter dangling=true --quiet)) || :
