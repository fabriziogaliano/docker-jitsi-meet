-- Plugins path gets uncommented during jitsi-meet-tokens package install - that's where token plugin is located
--plugin_paths = { "/usr/share/jitsi-meet/prosody-plugins/" }

VirtualHost "meet.<PROSODY_DOMAIN>"
        -- enabled = false -- Remove this line to enable this host
        authentication = "anonymous"
        -- Properties below are modified by jitsi-meet-tokens package config
        -- and authentication above is switched to "token"
        --app_id="example_app_id"
        --app_secret="example_app_secret"
        -- Assign this host a certificate for TLS, otherwise it would use the one
        -- set in the global section (if any).
        -- Note that old-style SSL on port 5223 only supports one certificate, and will always
        -- use the global one.
        -- ssl = {
        --         key = "/etc/prosody/certs/meet.<PROSODY_DOMAIN>.key";
        --         certificate = "/etc/prosody/certs/meet.<PROSODY_DOMAIN>.crt";
        -- }
        -- we need bosh
        modules_enabled = {
            "bosh";
            "pubsub";
            "ping"; -- Enable mod_ping
        }

        c2s_require_encryption = false

Component "conference.meet.<PROSODY_DOMAIN>" "muc"
    storage = "null"
    --modules_enabled = { "token_verification" }
admins = { "focus@auth.meet.<PROSODY_DOMAIN>" }

Component "jitsi-videobridge.meet.<PROSODY_DOMAIN>"
    component_secret = "<PASSWORD_JVBSECRET>"

VirtualHost "auth.meet.<PROSODY_DOMAIN>"
    -- ssl = {
    --     key = "/etc/prosody/certs/auth.meet.<PROSODY_DOMAIN>.key";
    --     certificate = "/etc/prosody/certs/auth.meet.<PROSODY_DOMAIN>.crt";
    -- }
    authentication = "internal_plain"

Component "focus.meet.<PROSODY_DOMAIN>"
    component_secret = "<PASSWORD_JICOFOSECRET>"