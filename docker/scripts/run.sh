#!/bin/bash

unset DEBIAN_FRONTEND

export PROSODY=`printenv | grep PROSODY_DOMAIN | awk -F'=' '{print $2}'`

export PASSWORD_JICOFOSECRET=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1`
export PASSWORD_JICOFOAUTH=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1`
export PASSWORD_JVBSECRET=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1`

cp /docker/configurations/jitsiJicofo/config /etc/jitsi/jicofo/config
cp /docker/configurations/jitsiVideobridge/config /etc/jitsi/videobridge/config

for var in $(printenv); do

    #explode vars to retrive key/value pairs
    IFS='=' read -r -a array <<< $var

    export KEY=${array[0]}

    if [[ $KEY =~ PROSODY_|JITSI_|PASSWORD_ ]]; then

        export VALUE=${array[1]}

        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/etc/jitsi/videobridge/config'
        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/etc/jitsi/jicofo/config'
        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/docker/scripts/jitsiDebconf.sh'
        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/etc/jitsi/jicofo/config'
        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/etc/jitsi/videobridge/config'
        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/docker/scripts/prosodyPwdfix.sh'

    fi

done

export LOG=/var/log/jitsi/jvb.log

if [ ! -f "$LOG" ]; then
	
	sed 's/#\ create\(.*\)/echo\ create\1 $JICOFO_AUTH_USER $JICOFO_AUTH_DOMAIN $JICOFO_AUTH_PASSWORD/' -i /var/lib/dpkg/info/jitsi-meet-prosody.postinst

    # dpkg-reconfigure jitsi-videobridge
    # rm /etc/jitsi/jicofo/config && dpkg-reconfigure jicofo

    /docker/scripts/jitsiDebconf.sh

	/var/lib/dpkg/info/jitsi-meet-prosody.postinst configure
	dpkg-reconfigure jitsi-meet

    /docker/scripts/prosodyPwdfix.sh

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
