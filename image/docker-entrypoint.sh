#!/bin/sh

##
## Verify ENV arguments
##

if ! [ "$MONGO_URI" ]; then
  MONGO_URI="mongodb://localhost:27017"
fi

if ! [ "$AMON_HOSTNAME" ]; then
  AMON_HOSTNAME="localhost"
fi

if ! [ "$AMON_PROTO" ] || ([ "$AMON_PROTO" != "http" ] && [ "$AMON_PROTO" != "https" ]); then
  AMON_PROTO="http"
fi

# Write config
cat > /etc/opt/amon/amon.yml << EOF
host: $AMON_PROTO://$AMON_HOSTNAME
mongo_uri: $MONGO_URI
smtp:
  host: 127.0.0.1
  port: 25
  use_tls: false
  sent_from: alerts@amon.cx
EOF

# Start nginx for static files
mkdir -p /run/nginx
nginx

# Init database
cd /opt/amon
python3 manage.py migrate
python3 manage.py installtasks

# Execute docker CMD
exec "$@"
