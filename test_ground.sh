#!/usr/bin/env bash

entry=$1
if [-z "${entry}"]; then
    echo "Component input is needed"
    exit 1
fi
