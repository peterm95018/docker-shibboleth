# Objective

This image is based on a shibboleth-sp debian image with added an configured apache and shibboleth
to launch a [sygefor](https://github.com/sygefor/sygefor) application with renater service provider.

This image is based on the work of [peterm95018](https://github.com/peterm95018/docker-shibboleth). Thanks to him !

# Actions to do

- Add 127.0.0.1 extranet.sygefor.dev and sygefor.dev in your hosts
- chown www-data. app/cache app/logs -R
