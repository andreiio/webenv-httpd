FROM ubuntu:16.04

RUN export DEBIAN_FRONTEND=noninteractive \
	&& apt-get update && apt-get install -y --no-install-recommends \
	apache2 \
	openssl \
	&& rm -rf /var/lib/apt/lists/*

COPY root /

CMD ["/init.sh"]

VOLUME ["/config", "/www"]

EXPOSE 80 443
