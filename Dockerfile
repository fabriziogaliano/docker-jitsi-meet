FROM debian:stretch

MAINTAINER Fabrizio Galiano <fabrizio.galiano@hotmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

ENV PROSODY_DOMAIN example.it
ENV JITSI_DOMAIN meet.example.it

#Install Prerequisites
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    wget \
    dnsutils \
    apt-utils \
    gnupg2 \
    vim \
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

EXPOSE 80 443 5347
EXPOSE 10000-10010/udp

COPY docker /docker

CMD /docker/scripts/run.sh