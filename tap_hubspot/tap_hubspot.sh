#!/bin/bash

set -e

COMMAND=$1

if [ "$COMMAND" == "discover" ];
then
    tap-hubspot -c /app/meta/config.json --discover
    tap-hubspot -c /app/meta/config.json --discover > /app/meta/properties.json
elif [ "$COMMAND" == "extract" ];
then
    tap-hubspot -c /app/meta/config.json --properties /app/meta/properties.json
fi