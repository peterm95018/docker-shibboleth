# Description

This repository permits to build images that can be used to launch a local SYGEFOR instance.
You can use the current docker-compose.yml to launch the needed containers.
One you have launched the maintenance container, you can use it to install SYGEFOR.
Then, you need to match sygefor.dev to 127.0.0.1 in your host file.

# Install sygefor

- docker exec -it sygefor_maintenance bash
- yarn
- npm install -g bower && bower install --allow-root
- composer install
- Fill-in the parameters
- php app/console doctrine:schema:update --force
- mkdir var/sessions && chown www-data. var/sessions
- mkdir var/Material var/Templates
- php app/console assets:install --symlink
- php app/console doctrine:fixtures:load
- php app/console fos:elastica:populate
- cd shell; sh clear-cache.sh
- Go to https://localhost and https://sygefor.com
