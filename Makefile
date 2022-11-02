clean:
	docker rmi ci -f

build:
	docker build -t ci .

run:
	docker run --name=snapd -ti -d \
      --tmpfs /run --tmpfs /run/lock --tmpfs /tmp \
      --privileged \
      -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
      -v /lib/modules:/lib/modules:ro \
      ci
