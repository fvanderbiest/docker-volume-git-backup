FROM debian:jessie

MAINTAINER fvanderbiest "francois.vanderbiest@gmail.com"

RUN apt-get update && \
    apt-get install -y git inotify-tools && \
		rm -rf /var/lib/apt/lists/*

ADD *.sh /
RUN chmod +x /entrypoint.sh

VOLUME [ "/var/local/data" ]
WORKDIR /var/local/data

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["bash", "-l", "/run.sh"]
