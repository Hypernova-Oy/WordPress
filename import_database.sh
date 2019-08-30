#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if ! [ -x "$(command -v wp)" ]; then
  echo 'Error: WP-CLI is not installed. Install it from https://wp-cli.org/' >&2
  exit 1
fi

read -e -p "Enter site URL: " -i "https://www.hypernova.fi" SITE_URL

read -e -p "Enter database name: " -i "hypernova" DB_NAME
read -e -p "Enter database user: " -i "hypernova" DB_USER
read -e -s -p "Enter database password [hypernova]:" DB_PASS
echo
read -e -p "Enter database hostname: " -i "localhost" DB_HOST
read -e -p "Enter database port: " -i "3306" DB_PORT

if [[ -z "$DB_PASS" ]]; then
    DB_PASS="hypernova"
fi

echo "Truncating data..."
mysql --user=$DB_USER --password=$DB_PASS -e "DROP DATABASE $DB_NAME; CREATE DATABASE $DB_NAME" -P$DB_PORT -h $DB_HOST $DB_NAME;
mysql --user=$DB_USER --password=$DB_PASS -P$DB_PORT -h $DB_HOST $DB_NAME < $DIR/hypernova-schema.sql;

echo "Importing dump..."
for filename in $DIR/data/*.txt
do
tablename=`basename $filename .txt`
mysql --user=$DB_USER --password=$DB_PASS -P$DB_PORT -h $DB_HOST $DB_NAME <<EOF
  SET FOREIGN_KEY_CHECKS=0;
  LOAD DATA INFILE '$filename' INTO TABLE \`$tablename\`;
EOF
done

wp user list --field=ID --allow-root | xargs -n 1 wp user session destroy --all --allow-root

wp search-replace http://homepage $SITE_URL --allow-root
