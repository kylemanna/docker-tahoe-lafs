# Leaner build then Ubunutu
FROM debian:jessie

MAINTAINER Kyle Manna <kyle@kylemanna.com>

RUN apt-get update && apt-get install -y tahoe-lafs dnsutils

RUN mkdir /tahoe && ln -s /tahoe /.tahoe

#RUN tahoe create-node
#RUN sed -ie 's:^#tub.port.*=:tub.port = 3456:' /tahoe/tahoe.cfg

ADD bin/ /usr/local/bin/
RUN chmod -R a+x /usr/local/bin

#RUN useradd -m -d /tahoe -s /bin/bash tahoe
#RUN mkdir -p /tahoe  && chown -R tahoe /tahoe
#USER tahoe

WORKDIR /tahoe

EXPOSE 3455 3456

VOLUME ["/tahoe"]
