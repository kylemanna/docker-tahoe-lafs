# Leaner build then Ubunutu
FROM debian:jessie

MAINTAINER Kyle Manna <kyle@kylemanna.com>

RUN apt-get update && apt-get install -y tahoe-lafs

RUN mkdir /tahoe && ln -s /tahoe /.tahoe
WORKDIR /tahoe

RUN tahoe create-node
RUN sed -ie 's:^#tub.port.*=:tub.port = 3456:' /tahoe/tahoe.cfg

EXPOSE 3455 3456

VOLUME ["/tahoe"]
