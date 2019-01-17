#!/bin/bash
#
# Dynamically updates the DNS configuration then runs the BIND9 server

# Exit the moment any single command fails
set -e

update_forwarders() {
  # Change which DNS server to foward requests to
  # If the env var is set...
  if [ ! -z ${VLAB_DNS_FORWARDERS+x} ]; then
    # replace comma with semicolon and a newline char
    local forwarders=$(echo ${VLAB_DNS_FORWARDERS} | sed 's/,/;\\\n\\\t\\\t/g')
    sed -i -e "s/8.8.8.8;/${forwarders}/g" /etc/bind/named.conf.options
  else
    echo "Using default DNS forwarder"
  fi
}

update_ddns_key() {
  # Use a user-supplied DDNS key
  if [ ! -z ${VLAB_DDNS_KEY+x} ]; then
    local key=$(echo ${VLAB_DDNS_KEY} | sed 's/\//\\\//g')
    sed -i -e "s/cmqR1rOrru0sK81Y3u5N784REV2yMdi8tQYjxWL4q35ny8ST7ifvwuPbVmyxPqcjj1VDhJ52ZTJQboOR5IhY\/A==/${key}/g" /etc/bind/ddns.key
  else
    echo "**SECURITY WARNING** Using default DDNS key"
  fi
}

update_rev_lookup_zone() {
  # The name matters, so it must match the IP subnet used
  if [ ! -z ${VLAB_DNS_REV_ZONE+x} ]; then
    sed -i -e "s/1.168.192.in-addr.arpa/${VLAB_DNS_REV_ZONE}/g" /etc/bind/named.conf.vlab
  else
    echo "Using default DNS reverse lookup zone"
  fi
}

update_vlab_ip() {
  # Set the IP resolution of the vLab FQDN
  if [ ! -z ${VLAB_IP+x} ]; then
    local server_ip=$(echo ${VLAB_IP} | cut -d. -f4)
    sed -i -e "s/192.168.1.2/${VLAB_IP}/g" /var/lib/bind/db.vlab
    sed -i -e "s/2    IN/${server_ip}    IN/g" /var/lib/bind/db.vlab.in-addr.arpa
  else
    echo "Using default vLab IP"
  fi
}

update_vlab_domain() {
  # Encase "vlab.com" isn't being used
  if [ ! -z ${VLAB_FQDN+x} ]; then
    sed -i -e "s/vlab.com/${VLAB_FQDN}/g" /etc/bind/named.conf.vlab
    sed -i -e "s/vlab.com/${VLAB_FQDN}/g" /var/lib/bind/db.vlab
    sed -i -e "s/vlab.com/${VLAB_FQDN}/g" /var/lib/bind/db.vlab.in-addr.arpa
  else
    echo "Using default vLab FQDN"
  fi
}

run_bind() {
  # the -f and -g flags send logs to stdout for Docker
  /usr/sbin/named -f -g -u bind
}

main () {
  # So only one function needs to be invoked for the whole script
  update_forwarders
  update_ddns_key
  update_rev_lookup_zone
  update_vlab_ip
  update_vlab_domain
  # This must *always* be last
  if [ -z ${TESTENV+x} ]; then
    run_bind
  fi
}
main
