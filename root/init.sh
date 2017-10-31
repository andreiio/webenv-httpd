#!/usr/bin/env bash

a2enmod proxy proxy_fcgi rewrite ssl vhost_alias

D="${DOMAIN:-web.env}"
F="${FCGI_URL:php}"

# Make sure permissions are right
UID=${UID:1000}
GID=${GID:1000}

usermod -o -u "$UID" www-data
groupmod -o -g "$GID" www-data

chown -R www-data:www-data /config
chown -R www-data:www-data /www

# Populate the /config dir if it's empty
if [ -d /config -a -z "$(ls -A /config)" ]; then

	mkdir -p /config/{ssl,sites}

	cp /httpd.conf /config/httpd.conf
	cp /sites/*.conf /config/sites

	sed -i "s/DOMAIN/$D/g; s/FCGI_URL/$FCGI_URL/g;" /config/sites/default.conf
fi

# Populate the /www dir if it's empty
if [ -d /www -a -z "$(ls -A /www)" ]; then
	mkdir -p www/$D
fi

# Generate self signed certificate for current domain
if [ ! -f "/config/ssl/$D.crt" ]; then
	conf="/config/ssl/$D-openssl.conf"
	path="/config/ssl/$D"

	cp /openssl.conf $conf
	sed -i "s/DOMAIN/$D/g" $conf

	openssl req -verbose -new -newkey rsa:2048 -days 3650 -nodes -x509 \
		-config $conf \
		-extensions v3_req \
		-keyout $path.key \
		-out $path.crt

	# Cleanup
	rm -- $conf
fi

# Remove old pid file
if [ -f /var/run/apache2/apache2.pid ]; then
	rm /var/run/apache2/apache2.pid
fi

# Start apache
apachectl -f /config/httpd.conf -DFOREGROUND
