#!/bin/bash

if ! [ -x "$(command -v wp)" ]; then
  echo 'Error: WP-CLI is not installed. Install it from https://wp-cli.org/' >&2
  exit 1
fi

read -e -p "Enter site URL: " -i "https://www.hypernova.fi" SITE_URL

read -e -p "Enter database name: " -i "hypernova" DB_NAME
read -e -p "Enter database user: " -i "hypernova" DB_USER
read -e -p "Enter database hostname: " -i "localhost" DB_HOST
read -e -p "Enter database port: " -i "3306" DB_PORT

mysql -u $DB_USER -p -P$DB_PORT -h $DB_HOST $DB_NAME < $DIR/hypernova.sql

wp search-replace http://homepage $SITE_URL --allow-root