#!/bin/bash

sed 's/Value:\slocalhost/Value: <JITSI_DOMAIN>/g' -i /var/cache/debconf/config.dat