# Apache

The Apache HTTP Server, colloquially called Apache, is a Web server application notable for playing a key role in the initial growth of the World Wide Web. Originally based on the NCSA HTTPd server, development of Apache began in early 1995 after work on the NCSA code stalled. Apache quickly overtook NCSA HTTPd as the dominant HTTP server, and has remained the most popular HTTP server in use since April 1996.

wikipedia.org/wiki/Apache\_HTTP\_Server

![apache logo](https://imgur.com/hOJRhwb.png)

## How to use this Makejail

### Hosting some simple static content

```
INCLUDE options/network.makejail
INCLUDE gh+AppJail-makejails/apache

COPY index.html /usr/local/www/apache24/data/index.html
CMD chown www:www /usr/local/www/apache24/data/index.html
```

Where `options/network.makejail` are the options that suit your environment, for example:

```
ARG network?
ARG interface=php

OPTION virtualnet=${network}:${interface} default
OPTION nat
```

Open a shell and run `appjail makejail`:

```sh
appjail makejail -j apache
```

### PHP

```
INCLUDE options/network.makejail
INCLUDE gh+AppJail-makejails/apache

COPY app.php /usr/local/www/apache24/data/app.php
CMD chown www:www /usr/local/www/apache24/data/app.php
```

Open a shell and run `appjail makejail`:

```sh
appjail makejail -j apache -- --apache_tag 13.2-php82
```

### Arguments

* `apache_tag` (default: `13.2`): see [#tags](#tags).

## How to build the Image

Make any changes you want to your image.

```
INCLUDE options/network.makejail
INCLUDE gh+AppJail-makejails/apache --file build.makejail

SYSRC apache24_enable=YES
```

Build the jail:

```sh
appjail makejail -j apache
# With php support:
appjail makejail -j apache -- \
    --apache_with_php 1 \
    --apache_php_version 82
```

Remove unportable or unnecessary files and directories and export the jail:

```sh
appjail stop apache
appjail cmd local apache sh -c "rm -f var/log/*"
appjail cmd local apache sh -c "rm -f var/cache/pkg/*"
appjail cmd local apache sh -c "rm -f var/run/*"
appjail cmd local apache vi etc/rc.conf
appjail image export apache
```

## Tags

| Tag          | Arch    | Version           | Type   |
| ------------ | ------- | ----------------- | ------ |
| `13.2`       | `amd64` | `13.2-RELEASE-p3` | `thin` |
| `13.2-php83` | `amd64` | `13.2-RELEASE-p3` | `thin` |
| `13.2-php82` | `amd64` | `13.2-RELEASE-p3` | `thin` |
| `13.2-php81` | `amd64` | `13.2-RELEASE-p3` | `thin` |
| `13.2-php80` | `amd64` | `13.2-RELEASE-p3` | `thin` |
