#!/bin/sh
export FLUENT_CONF=/etc/td-agent/td-agent.conf
export FLUENT_PLUGIN=/etc/td-agent/plugin
export FLUENT_SOCKET=/var/run/td-agent/td-agent.sock

/opt/td-agent/bin/fluentd --log /var/log/td-agent/td-agent.log --daemon /var/run/td-agent/td-agent.pid
