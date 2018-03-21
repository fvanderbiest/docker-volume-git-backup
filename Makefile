docker-build:
	docker pull debian:stretch
	docker build -t fvanderbiest/volume-git-backup:`date +%Y%m%d%H%M%S` .
	docker build -t fvanderbiest/volume-git-backup:latest .

docker-push:
	docker push fvanderbiest/volume-git-backup

all: docker-build
