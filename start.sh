#!/usr/bin/env bash

if [ "$1" = "live" ]; then
  ./cmd.sh -c start -l true
else
  ./cmd.sh -c start
fi
