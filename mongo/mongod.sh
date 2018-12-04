#!/bin/sh
mongod -f /etc/mongod.conf --fork

# Initiate replicaset
echo "rs.initiate()" | mongo
