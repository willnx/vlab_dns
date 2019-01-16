clean:
	-docker rm `docker ps -a -q`
	-docker rmi `docker images -q --filter "dangling=true"`
	-sudo rm /etc/bind/named*
	-sudo rm /var/lib/bind/db*
	-unset VLAB_DNS_FORWARDERS
	-unset VLAB_DNS_REV_ZONE
	-unset VLAB_IP
	-unset VLAB_FQDN
	-unset TESTENV

install: clean
	sudo cp dns/etc/bind/named* /etc/bind/
	sudo cp dns/var_lib/db* /var/lib/bind/

test: install
	sudo ./run_tests.sh

images:
	docker build -t willnx/vlab-dns .

up:
	docker-compose -p vlabDns up --abort-on-container-exit
