#!/usr/bin/env bash

COMPONENT=$1

## -z valdiates the input variable is empty; true if empty
if [ -z "${COMPONENT}" ]; then
    echo "Component input is needed"
    exit 1
fi

##manges AWS cli
LID=lt-03014931b58e68ec1
LVER=2


#aws ec2 run-instances --launch-template LaunchTemplateId=lt-03014931b58e68ec1,Version=2 --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=frontend}]'

##aws ec2 run-instances --launch-template LaunchTemplateId=${LID},Version=${LVER} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}]"


