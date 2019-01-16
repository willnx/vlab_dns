FROM ubuntu:18.04

RUN apt update && apt upgrade --yes
RUN apt-get install -y bind9
RUN chown -R bind:root /etc/bind && \
    touch /var/log/querylog.log && \
    chown bind:root /var/log/querylog.log

COPY dns/usr.sbin.named /etc/apparmor.d/
COPY dns/etc/bind/ /etc/bind/
COPY dns/var_lib/ /var/lib/bind/
COPY dns/config_and_run.sh /usr/sbin
CMD /usr/sbin/config_and_run.sh
