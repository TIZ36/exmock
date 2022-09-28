#!/bin/bash

# echo "$@"

echo "ok" > /tmp/readiness_probe
source ~/.bashrc
mix ecto.create
mix ecto.migrate
./start.sh