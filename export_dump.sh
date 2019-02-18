#!/bin/bash

USERNAME="hypernova"
PASSWORD="hypernova"
DATABASE="hypernova"

ARGS="--user=$USERNAME --password=$PASSWORD --opt --skip-dump-date"
/usr/bin/mysqldump $ARGS $DATABASE | sed 's$VALUES ($VALUES\n($g' | sed 's$),($),\n($g' > hypernova.sql
