FROM debian:stretch

MAINTAINER fvanderbiest "francois.vanderbiest@gmail.com"

RUN apt-get update && \
    apt-get install -y git inotify-tools && \
		rm -rf /var/lib/apt/lists/* /usr/share/doc/* /usr/share/man/*

COPY scripts/*.sh /
RUN chmod +x /entrypoint.sh

VOLUME [ "/var/local/data" ]
WORKDIR /var/local/data

ENV REMOTE_BRANCH master

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["bash", "-l", "/run.sh"]
