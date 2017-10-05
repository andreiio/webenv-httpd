# webenv-httpd

[![](https://images.microbadger.com/badges/image/andreiio/webenv-httpd.svg)](https://microbadger.com/images/andreiio/webenv-httpd)

Apache docker image for local development that generates a self-signed wildcard certificate on the first run, based on the `DOMAIN` environment variable.

Check out the main [webenv](https://github.com/andreiio/webenv) repo for more information.

## Usage
```
docker create \
--name=webenv-httpd \
-p 80:80 \
-p 443:443 \
-e DOMAIN=<example.tld> \
-e FCGI_URL=<hostname> \
-v </path/to/config>:/config \
-v </path/to/www>:/www \
andreiio/webenv-httpd
```
