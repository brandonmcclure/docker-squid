# fork of repo https://github.com/sameersbn/docker-squid/issues/68
FROM alpine:3.12.1
LABEL maintainer="sameer@damagehead.com"

ENV SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=proxy

RUN apk update --no-cache \
 && apk add bash squid --no-cache

RUN adduser --system proxy \
&& addgroup --system proxy \
&& mkdir "$SQUID_CACHE_DIR/" \
&& chown -R proxy:proxy "$SQUID_LOG_DIR/" \
&& chown -R proxy:proxy /var/cache/squid/ \
&& chown -R proxy:proxy "$SQUID_CACHE_DIR/" \
&& chown -R proxy:proxy /var/run/ 

RUN /usr/lib/squid/security_file_certgen -c -s /var/lib/ssl_db -M 4MB \
&& chown -R proxy:proxy /var/lib/ssl_db

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh
USER proxy:proxy
EXPOSE 3128/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]
