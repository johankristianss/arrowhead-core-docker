#!/bin/sh

# Created by Jesper Frisk (https://github.com/MrDweller)

# Generates a certificate for a custom system that should be used in arrowhead.

# The environment variable PASSWORD is used to set the password of all created key stores, this variable must be set.
# The environment variable ROOT_NAME is the name of the root/master certificate. Defualts to "master".
# The environment variable CLOUD_NAME is the name of the cloud certificate. Defualts to "cloud".
# The environment variable COMPANY_NAME is the name of the company/organization. Defualts to "ltu".

# @param -n System name. This is the name of the system that the certificate will be generated for, this variable must be set.
# @param -d System certificate directory. This variable represents where the certificate will be stored. Defualts to "<SYSTEM_NAME>/certificates/".
# @param -s Subject alternative name parameters. Sets extra ips or dns, example: "ip:192.168.1.1". Defualts to empty string.

while getopts n:d: flag
do
  case "${flag}" in
    n) SYSTEM_NAME=${OPTARG};;
    d) SYSTEM_CERT_DIR=${OPTARG};;
  esac
done

if [[ -z "${SYSTEM_NAME}" ]]; then
  echo "You must enter a system name, enter -n"
  exit 1
fi
if [[ -z "${SYSTEM_CERT_DIR}" ]]; then
  SYSTEM_CERT_DIR="${SYSTEM_NAME}/certificates/"
fi

echo "Using system name: $SYSTEM_NAME"
echo "Using system certificate directory: $SYSTEM_CERT_DIR"

cd ../
source "./certificate-generation-scripts/load_input.sh"
source "./certificate-generation-scripts/lib_certs.sh"


rm -r ${SYSTEM_NAME}/certificates

create_system_keystore \
    "certificates/${ROOT_NAME}.p12" "arrowhead.eu" \
    "certificates/${CLOUD_NAME}.p12" "${CLOUD_NAME}.${COMPANY_NAME}.arrowhead.eu" \
    "./$SYSTEM_CERT_DIR/${SYSTEM_NAME}.p12" "${SYSTEM_NAME}.${CLOUD_NAME}.${COMPANY_NAME}.arrowhead.eu" "${SYSTEM_NAME}" \
    "dns:${SYSTEM_NAME},dns:host.docker.internal,dns:localhost,ip:127.0.0.1,${SUBJECT_ALTERNATIVE_NAME}"

cp certificates/truststore.p12 ./$SYSTEM_CERT_DIR/truststore.p12 
