FROM ubuntu:18.04

RUN apt update && apt upgrade --yes
RUN apt-get install -y bind9

COPY dns/etc/bind/ /etc/bind/
COPY dns/var_lib/ /var/lib/bind/
