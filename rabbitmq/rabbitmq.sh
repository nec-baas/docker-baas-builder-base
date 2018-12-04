#!/bin/sh
# Note: /usr/sbin/rabbitmq-server は使用しない (root/rabbitmqいずれのユーザでも無いため)

HOME=/var/lib/rabbitmq /usr/lib/rabbitmq/bin/rabbitmq-server --detached &

