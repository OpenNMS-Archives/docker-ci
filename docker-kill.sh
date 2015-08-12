#!/bin/bash -e

(docker kill $(docker ps -aq)) || :
