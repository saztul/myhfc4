#!/bin/sh
docker stop $(docker ps | grep myhfc4 | cut -d" " -f1 )