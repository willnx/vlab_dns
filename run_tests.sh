#!/bin/bash
#
# Script to run all tests

sudo named-checkconf -t `pwd`/dns || echo "Bad zone config"
sudo named-checkzone vlab.com dns/var_lib/db.vlab
sudo named-checkzone vlab.com dns/var_lib/db.vlab.in-addr.arpa
export VLAB_DNS_FORWARDERS=10.7.190.6,10.7.190.7,
export VLAB_DNS_REV_ZONE=80.241.10.in-addr.arpa
export VLAB_IP=10.241.80.12
export VLAB_FQDN=vlab-dev.igs.corp
export TESTENV=true
dns/config_and_run.sh
