clean:
	docker rmi neppel/ci -f

build:
	docker build -t neppel/ci .

install-charmcraft:
	docker exec -it ci snap install charmcraft --classic

install-juju:
	docker exec -it ci snap install juju --classic

install-lxd:
	docker exec -it ci snap install lxd

install-microk8s:
	docker exec -it ci snap install microk8s --classic

start:
	docker run --name=ci -ti -d \
      --tmpfs /run --tmpfs /run/lock --tmpfs /tmp \
      --privileged \
      -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
      -v /lib/modules:/lib/modules:ro \
      neppel/ci

stop:
	docker rm --force ci
