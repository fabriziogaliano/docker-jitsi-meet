FROM debian:stretch

MAINTAINER Fabrizio Galiano <fabrizio.galiano@hotmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

#Install Prerequisites
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    wget \
    dnsutils \
    apt-utils \
    gnupg2 \
    vim \
    telnet \
    authbind \
    nginx

#Add JAVA/JITSI repos
RUN echo "deb http://http.debian.net/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list && \
    sh -c "echo 'deb https://download.jitsi.org stable/' > /etc/apt/sources.list.d/jitsi-stable.list" && \
    wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | apt-key add - && \
    apt-get update

#Install Java Runtime
RUN apt-get install -y \
    ca-certificates-java

#Install JITSI
RUN apt-get install -y \
    jitsi-videobridge \
    jicofo \
    jigasi \
    jitsi-meet

#CleanUp Apt
RUN apt-get clean

#ENV PUBLIC_HOSTNAME=192.168.59.103
#/etc/jitsi/meet/localhost-config.js = bosh: '//localhost/http-bind',
#RUN sed s/JVB_HOSTNAME=/JVB_HOSTNAME=$PUBLIC_HOSTNAME/ -i /etc/jitsi/videobridge/config && \
#	sed s/JICOFO_HOSTNAME=/JICOFO_HOSTNAME=$PUBLIC_HOSTNAME/ -i /etc/jitsi/jicofo/config

EXPOSE 80 443 5347
EXPOSE 10000/udp 10001/udp 10002/udp 10003/udp 10004/udp 10005/udp 10006/udp 10007/udp 10008/udp 10009/udp 10010/udp

COPY docker /docker

CMD /docker/scripts/run.sh
