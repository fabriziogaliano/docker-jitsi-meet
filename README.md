# docker-jitsi-meet

Docker container for [jitsi-meet][3]

> Jitsi Meet is an open-source (MIT) WebRTC JavaScript application that uses Jitsi Videobridge to provide high quality, scalable video conferences."  "Jitsi Meet allows for very efficient collaboration. It allows users to stream their desktop or only some windows. It also supports shared document editing with Etherpad and remote presentations with Prezi.

## Usage (downloading pre-built image from Docker Hub)

	$ docker run -it --name jitsi-meet -p 443:443 fabriziogaliano/jitsi-meet

## Accessing the web app:

After that open up the following address :

  - **https://$DOCKER_HOST/**


## More Info

About jitsi-meet: [www.jitsi.org][1]

To help improve this container [docker-jitsi-meet][5]


[1]:https://jitsi.org/
[2]:https://www.docker.com
[3]:https://jitsi.org/
[4]:http://docs.docker.com
[5]:https://github.com/fabriziogaliano/docker-jitsi-meet
