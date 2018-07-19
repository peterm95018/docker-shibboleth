# Description

This image contains PHP5, Apache2, [Shibboleth](https://en.wikipedia.org/wiki/Shibboleth_(Shibboleth_Consortium) and the mail utils needed to make Sygefor3 works.

You can override the [shibboleth2.xml](https://github.com/sygefor/docker-shibboleth/blob/master/shibboleth-sp/shibboleth2.xml) file
to use your own entityID, discoveryProtocol, MetadataProviders and certificates for Shibboleth.
 
To use this image, you can build it with build.sh and then call the sygefor/shibboleth_sp image.

You can use and extend the docker-compose.dist to launch your Sygefor containers. You need to make a correspondence between
127.0.0.1 and sygefor.com on your computer host file.

The following Sygefor repositories must be writable by the user www-data :
 - app/cache
 - app/logs
 - var/Material
 - var/Publipost 
