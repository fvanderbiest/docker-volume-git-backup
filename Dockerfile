FROM debian:stretch

MAINTAINER fvanderbiest "francois.vanderbiest@gmail.com"

ENV REMOTE_BRANCH=master \
    USERID=999 \
    GROUPID=999

RUN apt-get update && \
    apt-get install -y git inotify-tools && \
		rm -rf /var/lib/apt/lists/* /usr/share/doc/* /usr/share/man/*

RUN groupadd --gid $GROUPID committer && \
    useradd -ms /bin/bash --home /home/committer --uid $USERID --gid $GROUPID committer

COPY scripts/*.sh /
RUN chmod +x /entrypoint.sh

RUN mkdir /var/local/data && \
    chown -R $USERID:$GROUPID /var/local/data
VOLUME [ "/var/local/data" ]
WORKDIR /var/local/data

USER committer
ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["bash", "-l", "/run.sh"]
