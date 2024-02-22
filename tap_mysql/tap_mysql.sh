#!/bin/bash

set -e

COMMAND=$1

if [ "$COMMAND" == "discover" ];
then
    tap-mysql -c /app/meta/config.json --discover
    tap-mysql -c /app/meta/config.json --discover > /app/meta/properties.json
elif [ "$COMMAND" == "extract" ];
then
    tap-mysql -c /app/meta/config.json --properties /app/meta/properties.json
fi

