#!/usr/bin/env bash

COMPONENT=$1
if [ -z "${COMPONENT}" ]; then
  echo "Component Input is Needed"
  exit 1
fi
