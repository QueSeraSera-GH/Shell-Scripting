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

##aws ec2 run-instances --launch-template LaunchTemplateId=${LID},Version=${LVER} --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]"

## Validate If Instance is already there

DNS_UPDATE() {
  PRIVATEIP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}"  | jq .Reservations[].Instances[].PrivateIpAddress | xargs -n1)
  sed -e "s/COMPONENT/${COMPONENT}/" -e "s/IPADDRESS/${PRIVATEIP}/" record.json >/tmp/record.json
  aws route53 change-resource-record-sets --hosted-zone-id Z04221902CM9ZT2GHM1NW --change-batch file:///tmp/record.json | jq
}

INSTANCE_CREATE() {
  INSTANCE_STATE=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${COMPONENT}"  | jq .Reservations[].Instances[].State.Name | xargs -n1)
  if [ "${INSTANCE_STATE}" = "running" ]; then
    echo "${COMPONENT} Instance already exists!!"
    DNS_UPDATE
    return 0
  fi

  if [ "${INSTANCE_STATE}" = "stopped" ]; then
    echo "${COMPONENT} Instance already exists!!"
    return 0
  fi

  echo -n Instance ${COMPONENT} created - IPADDRESS is
  aws ec2 run-instances --launch-template LaunchTemplateId=${LID},Version=${LVER}  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" | jq | grep  PrivateIpAddress  |xargs -n1
  sleep 10
  DNS_UPDATE
}

if [ "${1}" == "all" ]; then
  for component in frontend mongodb catalogue redis user cart mysql shipping rabbitmq payment ; do
    COMPONENT=$component
    INSTANCE_CREATE
  done
else
  COMPONENT=$1
  INSTANCE_CREATE
fi
