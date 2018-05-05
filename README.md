# docker-jitsi-meet

Docker image for [jitsi-meet][3] based on Debian Stretch
> ## ---> This image was designed to be used behind an SSL Proxy, please consider this <--- ##

> Jitsi Meet is an open-source (MIT) WebRTC JavaScript application that uses Jitsi Videobridge to provide high quality, scalable video conferences."  "Jitsi Meet allows for very efficient collaboration. It allows users to stream their desktop or only some windows. It also supports shared document editing with Etherpad and remote presentations with Prezi.

## Usage (downloading pre-built image from Docker Hub)

	$ docker run -it --name jitsi-meet -p 80:80 fabriziogaliano/jitsi-meet

## Accessing the web app:

After that open up the following address :

  - **http://$DOCKER_HOST/**

## Docker compose file example with [traefik][6] label 

```
version: '2'

networks:
  default:
    external:
      name: private

services:
   jitsi:
      image: fabriziogaliano/jitsi-meet:v0.2

      container_name: jitsi

      labels:
         - 'traefik.enable=true'
         - 'traefik.docker.network=private'

         - 'traefik.jitsi.backend=meet_domain_it'
         - 'traefik.jitsi.port=80'
         - 'traefik.jitsi.protocol=http'
         - 'traefik.jitsi.frontend.rule=Host:meet.domain.it'
         - 'traefik.jitsi.frontend.passHostHeader=true'
         - 'traefik.jitsi.frontend.entryPoints=http,https'

      restart: always
```
## More info

About jitsi-meet: [www.jitsi.org][1]

To help improve this container [docker-jitsi-meet][5]


[1]:https://jitsi.org/
[2]:https://www.docker.com
[3]:https://jitsi.org/
[4]:http://docs.docker.com
[5]:https://github.com/fabriziogaliano/docker-jitsi-meet
[6]:https://github.com/containous/traefik