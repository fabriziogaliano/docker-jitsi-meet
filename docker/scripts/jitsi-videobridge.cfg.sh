#!/usr/bin/expect

spawn dpkg-reconfigure jitsi-videobridge
expect "Hostname:"
send "zombox.it\r"