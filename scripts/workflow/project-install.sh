#!/bin/bash

# Exit immediately on errors, and echo commands as they are executed.
set -ex

echo "Get composer dependencies."
composer install

echo "Installing project..."
cd web
# Using ../vendor/bin/drush to ensure this script works out of the box.
../vendor/bin/drush site-install minimal --config-dir=../config/sync --account-name=admin --account-pass=admin -y

echo "Importing default content."
../vendor/bin/drush en dvt_default_content -y
../vendor/bin/drush cim -y --partial --source=modules/custom/dvt_default_content/config/optional/
../vendor/bin/drush mim --group=default_content --update
../vendor/bin/drush pm-uninstall migrate -y

echo "Clearing cache."
../vendor/bin/drush cr
