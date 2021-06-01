#!/usr/bin/env bash

COURSE=DevOps

echo Course Name = $COURSE


DATE=$(date +%F)

echo "Good Morning, Today's date is $DATE"

num_users=$(who | wc -l)
echo "There are $num_users currently logged in"

cal 8 2020