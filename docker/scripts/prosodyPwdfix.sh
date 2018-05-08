# Change configuration of Prosody to be alligned with password auto generated
cp /docker/configurations/prosody/meet.example.cfg.lua /etc/prosody/conf.available/meet.<PROSODY_DOMAIN>.cfg.lua

for var in $(printenv); do

    #explode vars to retrive key/value pairs
    IFS='=' read -r -a array <<< $var

    export KEY=${array[0]}

    if [[ $KEY =~ PROSODY_|JITSI_|PASSWORD_ ]]; then

        export VALUE=${array[1]}

        sed -i -e 's|<'$KEY'>|'$VALUE'|g' '/etc/prosody/conf.avail/meet.<PROSODY_DOMAIN>.cfg.lua'

    fi

done