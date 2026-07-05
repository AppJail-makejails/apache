# Apache

The Apache HTTP Server, colloquially called Apache, is a Web server application notable for playing a key role in the initial growth of the World Wide Web. Originally based on the NCSA HTTPd server, development of Apache began in early 1995 after work on the NCSA code stalled. Apache quickly overtook NCSA HTTPd as the dominant HTTP server, and has remained the most popular HTTP server in use since April 1996.

wikipedia.org/wiki/Apache_HTTP_Server

<img src="https://camo.githubusercontent.com/3d4134d5e716dc34f160a207f32e5a5d8d06a27c9fd4452ff79245910d3b9103/68747470733a2f2f696d6775722e636f6d2f684f4a526877622e706e67" width="30%" height="auto" alt="Apache logo">

## How to use this Makejail

### Create a `Containerfile`in your project

```dockerfile
FROM ghcr.io/appjail-makejails/apache:15.1-24
COPY ./public-html/ /usr/local/www/apache24/data/
```

Then, run the commands to build and run the OCI image:

```console
$ buildah build --network=host -t my-apache2 .
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    localhost/my-apache2 my-running-app
...
[00:00:25] [ info  ] [my-running-app] Detached: pid:20568, log:jails/my-running-app/container/2026-07-03.log
$ appjail jail list -j my-running-app
STATUS  NAME            ALT_NAME  TYPE   VERSION       PORTS  NETWORK_IP4
UP      my-running-app  -         thick  15.1-RELEASE  -      10.0.0.9
```

Visit http://10.0.0.9:8080 and you will see It works!

### Without a `Containerfile`

If you don't want to include a `Containerfile` in your project, it is sufficient to do the following:

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -o fstab="$PWD /usr/local/www/apache24/data/ nullfs ro" \
    ghcr.io/appjail-makejails/apache:15.1-24 my-apache-app
```

### Configuration

To customize the configuration of the httpd server, first obtain the upstream default configuration from the container:

```console
$ appjail oci run \
    -o overwrite=force \
    -o ephemeral \
    -o virtualnet=":<random> default" \
    -o nat \
    ghcr.io/appjail-makejails/apache:15.1-24 my-apache-app cat /dev/null
$ appjail oci exec my-apache-app cat /usr/local/etc/apache24/httpd.conf > my-httpd.conf
```

You can then `COPY` your custom configuration in as `/usr/local/etc/apache24/httpd.conf`:

```dockerfile
FROM ghcr.io/appjail-makejails/apache:15.1-24
COPY ./my-httpd.conf /usr/local/etc/apache24/httpd.conf
```

### TLS/HTTPS

If you want to run your web traffic over SSL, the simplest setup is to `COPY` or mount (`-o fstab`) your `server.crt` and `server.key` into `/usr/local/etc/apache24/` and then customize the `/usr/local/etc/apache24/httpd.conf` by removing the comment symbol from the following lines:

```apache
...
#LoadModule socache_shmcb_module libexec/apache24/mod_socache_shmcb.so
...
#LoadModule ssl_module libexec/apache24/mod_ssl.so
...
#Include etc/apache24/extra/httpd-ssl.conf
...
```

The `etc/apache24/extra/httpd-ssl.conf` configuration file will use the certificate files previously added and tell the daemon to also listen on port 443. Be sure to also add something like `-o expose=443` to your `appjail oci run` to forward the https port.

The previous steps should work well for development, but we recommend customizing your conf files for production, see [httpd.apache.org](https://httpd.apache.org/docs/2.4/ssl/ssl_faq.html) for more information about SSL setup.

### PHP support

You can easily add PHP support to a custom image. Just install `mod_phpXX` and configure httpd.

If you just want a ready-made image, use a tag that includes PHP, which also configures httpd.

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -o fstab="$PWD/index.php /usr/local/www/apache24/data/index.php nullfs ro" \
    ghcr.io/appjail-makejails/apache:15.1-24-php85 my-php-app
```

### Arguments (stage: build)

* `apache_from` (default: `ghcr.io/appjail-makejails/apache`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `apache_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).


## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1-24
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
        APACHEVER: "24"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache:/var/cache/pkg"]
    - tag: 15.1-24-php82
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        APACHEVER: "24"
        PHPVER: "82"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache:/var/cache/pkg"]
    - tag: 15.1-24-php83
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        APACHEVER: "24"
        PHPVER: "83"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache:/var/cache/pkg"]
    - tag: 15.1-24-php84
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        APACHEVER: "24"
        PHPVER: "84"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache:/var/cache/pkg"]
    - tag: 15.1-24-php85
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        APACHEVER: "24"
        PHPVER: "85"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache:/var/cache/pkg"]
```

## Notes

1. `/var/log/httpd-error.log` has a symbolic link to `/dev/stderr`, as do `/var/log/httpd-access.log` and `/var/log/httpd-ssl_request.log`, which has a symbolic link to `/dev/stdout`.
2. The ideas present in the Docker image of httpd are taken into account for users who are familiar with it.
