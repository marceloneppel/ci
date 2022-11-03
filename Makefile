clean:
	docker rmi neppel/ci -f

build:
	docker build -t neppel/ci .

publish:
	docker push neppel/ci

start:
	docker create --name=ci --entrypoint "tail" neppel/ci "-f" "/dev/null"
	docker start ci

stop:
	docker rm --force ci
