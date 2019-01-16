clean:
	-docker rm `docker ps -a -q`
	-docker rmi `docker images -q --filter "dangling=true"`

test:
	sudo named-checkconf -t `pwd`/dns

images:
	docker build -t willnx/vlab-dns .

up:
	docker-compose -p vlabDns up --abort-on-container-exit
