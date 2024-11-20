#!/bin/sh

source "../../.env"

# The environment variable ROOT_NAME is the name of the root/master certificate. Defualts to "master".
# The environment variable CLOUD_NAME is the name of the cloud certificate. Defualts to "cloud".
# The environment variable COMPANY_NAME is the name of the company/organization. Defualts to "ltu".

# @param -s Subject alternative name parameters. Sets extra ips or dns, example: "ip:192.168.1.1". Defualts to empty string.

while getopts s: flag
do
  case "${flag}" in
    s) SUBJECT_ALTERNATIVE_NAME=${OPTARG};;
  esac
done

if [[ -z "${PASSWORD}" ]]; then
  echo "You must create a '.env' file with the variable 'PASSWORD'"
  exit 1
fi

if [[ -z "${ROOT_NAME}" ]]; then
  ROOT_NAME="master"
fi

if [[ -z "${CLOUD_NAME}" ]]; then
  CLOUD_NAME="cloud"
fi

if [[ -z "${COMPANY_NAME}" ]]; then
  COMPANY_NAME="ltu"
fi

if [[ -z "${SUBJECT_ALTERNATIVE_NAME}" ]]; then
  SUBJECT_ALTERNATIVE_NAME=""
fi

echo "Using root/master name: $ROOT_NAME"
echo "Using cloud name: $CLOUD_NAME"
echo "Using company name: $COMPANY_NAME"
echo "Using extra subject alternative name parameters: $SUBJECT_ALTERNATIVE_NAME"
