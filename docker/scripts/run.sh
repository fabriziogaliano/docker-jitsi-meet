unset DEBIAN_FRONTEND

cp /docker/configurations/prosody/meet.example.cfg.lua /etc/prosody/conf.d/meet.example.cfg.lua

for var in $(printenv); do

    #explode vars to retrive key/value pairs
    IFS='=' read -r -a array <<< $var

    export KEY=${array[0]}

    if [[ $KEY =~ PROSODY_ ]]; then

        export VALUE=${array[1]}

        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/etc/prosody/conf.d/meet.example.cfg.lua'
        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/etc/jitsi/videobridge/config'

    fi

done

export LOG=/var/log/jitsi/jvb.log

if [ ! -f "$LOG" ]; then
	
	sed 's/#\ create\(.*\)/echo\ create\1 $JICOFO_AUTH_USER $JICOFO_AUTH_DOMAIN $JICOFO_AUTH_PASSWORD/' -i /var/lib/dpkg/info/jitsi-meet-prosody.postinst

	dpkg-reconfigure jitsi-videobridge
	rm /etc/jitsi/jicofo/config && dpkg-reconfigure jicofo
	/var/lib/dpkg/info/jitsi-meet-prosody.postinst configure
	dpkg-reconfigure jitsi-meet

	touch $LOG && \
	chown jvb:jitsi $LOG
fi


#Configure custom nginx file (Insecure HTTP), please run behind an SSL Proxy
rm /etc/nginx/sites-enabled/ok.conf 
rm /etc/nginx/sites-enabled/default
cp /docker/configurations/nginx/jitsi-meet /etc/nginx/sites-enabled/jitsi-meet.conf

cd /etc/init.d/

./prosody restart && \
./jitsi-videobridge restart && \
./jicofo restart && \
./nginx restart

tail -f $LOG
