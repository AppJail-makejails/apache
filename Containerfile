ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/core:${FREEBSD_RELEASE}

ARG APACHEVER
ARG PHPVER
ARG NO_PKGCLEAN

LABEL org.opencontainers.image.title="httpd" \
    org.opencontainers.image.description="High performance Unix-based HTTP server" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/apache" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/apache" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe -o pipefail; \
    \
    pkg update; \
    pkg install -U apache${APACHEVER}; \
    \
    mkdir -p /usr/local/www/html; \
    chmod 555 /usr/local/www/html; \
    \
    if [ -n "${PHPVER}" ]; then \
        pkg install -U mod_php${PHPVER}; \
        { \
            echo -e '<FilesMatch \.php$>'; \
            echo -e '\tSetHandler application/x-httpd-php'; \
            echo -e '</FilesMatch>'; \
            echo; \
            echo -e 'DirectoryIndex disabled'; \
            echo -e 'DirectoryIndex index.php index.html'; \
            echo; \
            echo -e '<Directory /usr/local/www/apache24/data/>'; \
            echo -e '\tOptions -Indexes'; \
            echo -e '\tAllowOverride All'; \
            echo -e '</Directory>'; \
        } | tee /usr/local/etc/apache24/Includes/appjail-php.conf; \
    fi; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/* /var/db/pkg/repos/*; \
    fi; \
    \
    ln -sf /dev/stderr /var/log/httpd-error.log; \
    ln -sf /dev/stdout /var/log/httpd-access.log; \
    ln -sf /dev/stdout /var/log/httpd-ssl_request.log;

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

STOPSIGNAL SIGWINCH

WORKDIR /usr/local

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
