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
appjail makejail -j apache -- --apache_tag 13.3-php82
```

### Arguments

* `apache_tag` (default: `13.3`): see [#tags](#tags).

## Tags

| Tag          | Arch    | Version        | Type   | `apache_with_php` | `apache_php_version` |
| ------------ | ------- | -------------- | ------ | ----------------- | -------------------- |
| `13.3`       | `amd64` | `13.3-RELEASE` | `thin` |        `0`        |          -           |
| `13.3-php83` | `amd64` | `13.3-RELEASE` | `thin` |        `1`        |         `83`         |
| `13.3-php82` | `amd64` | `13.3-RELEASE` | `thin` |        `1`        |         `82`         |
| `13.3-php81` | `amd64` | `13.3-RELEASE` | `thin` |        `1`        |         `81`         |
| `14.0`       | `amd64` | `14.0-RELEASE` | `thin` |        `0`        |          -           |
| `14.0-php83` | `amd64` | `14.0-RELEASE` | `thin` |        `1`        |         `83`         |
| `14.0-php82` | `amd64` | `14.0-RELEASE` | `thin` |        `1`        |         `82`         |
| `14.0-php81` | `amd64` | `14.0-RELEASE` | `thin` |        `1`        |         `81`         |
