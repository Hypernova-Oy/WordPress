#!/bin/bash

USERNAME="hypernova"
PASSWORD="hypernova"
DATABASE="hypernova"

ARGS="--user=$USERNAME --password=$PASSWORD --opt --skip-dump-date"
# https://stackoverflow.com/questions/15750535/using-mysqldump-to-format-one-insert-per-line
/usr/bin/mysqldump $ARGS $DATABASE | sed 's$VALUES ($VALUES\n($g' | sed 's$),($),\n($g' > hypernova.sql
echo "DELETE FROM wp_options WHERE option_name='wpml_language_switcher_template_objects';\n" >> hypernova.sql
