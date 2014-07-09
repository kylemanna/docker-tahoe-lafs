# Leaner build then Ubuntu
FROM debian:jessie

MAINTAINER Kyle Manna <kyle@kylemanna.com>

RUN apt-get update && apt-get install -y tahoe-lafs dnsutils openvpn supervisor

RUN mkdir /tahoe && ln -s /tahoe /.tahoe

ADD etc/ /etc/
ADD bin/ /usr/local/bin/
RUN chmod -R a+x /usr/local/bin

#RUN useradd -m -d /tahoe -s /bin/bash tahoe
#RUN mkdir -p /tahoe  && chown -R tahoe /tahoe
#USER tahoe

WORKDIR /tahoe

VOLUME ["/tahoe"]

# Don't specify supervisord config file (despite security warnings) so that a
# user can override the default by placing a config file at
# /tahoe/supervisord.conf with custom options and still use the default CMD.
CMD ["supervisord"]
