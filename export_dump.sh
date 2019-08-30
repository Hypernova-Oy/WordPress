#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

USERNAME="hypernova"
PASSWORD="hypernova"
DATABASE="hypernova"

ARGS="--user=$USERNAME --password=$PASSWORD --opt --skip-dump-date"

# Export schema
/usr/bin/mysqldump --no-data $ARGS $DATABASE > hypernova-schema.sql

# Take dump of each table
sudo chmod g+w $DIR/data
sudo chown :mysql $DIR/data
/usr/bin/mysqldump --skip-extended-insert $ARGS --tab=$DIR/data $DATABASE
rm $DIR/data/*.sql

# "DELETE FROM wp_options WHERE option_name='wpml_language_switcher_template_objects';\n"
sed -i '/wpml_language_switcher_template_objects/d' $DIR/data/wp_options.txt
