FROM debian:jessie

MAINTAINER fvanderbiest "francois.vanderbiest@gmail.com"

RUN apt-get update && \
    apt-get install -y python-dev && \
		rm -rf /var/lib/apt/lists/*

ADD change.py .

VOLUME [ "/opt/geoserver_data_dir" ]

CMD ["python", "change.py"]
