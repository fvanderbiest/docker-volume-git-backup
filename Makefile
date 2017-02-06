docker-build:
	docker pull debian:jessie
	docker build -t fvanderbiest/volume-git-backup:`date +%Y%m%d%H%M%S` .

all: docker-build