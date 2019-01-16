.. image:: https://travis-ci.org/willnx/vlab_dns.svg?branch=master
    :target: https://travis-ci.org/willnx/vlab_dns

########
vLab DNS
########

This service centralizes DNS for all of vLab. The services that make up vLab, as
well as all VMs inside user's labs, will rely on this service by default to
perform DNS name resolutions.

*********************
Environment Variables
*********************

Every deployment of vLab is going to have unique needs for DNS because the
likely hood of the subnet and FQDN being identical between deployments is
zero.

To accommodate this, the entry point script of the container will read the following
environment variables and update the default configs accordingly:

- ``VLAB_DDNS_KEY`` - The HMAC-SHA512 key required by client to perform Dynamtic DNS updates
- ``VLAB_DNS_FORWARDERS`` - A comma-seperated list of DNS servers to forward queries to; value must have a trailing comma
- ``VLAB_DNS_REV_ZONE`` - The /24 reverse zone name, ex "1.168.192.in-addr.arpa" for the 192.168.1.0/24 subnet
- ``VLAB_IP`` - The IPv4 Address of the vLab server
- ``VLAB_FQDN`` - The fully qualified domain name for the vLab server, ex vlab.mycompany.com
