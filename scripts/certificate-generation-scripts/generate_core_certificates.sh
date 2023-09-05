#!/bin/sh

# Created by Jesper Frisk (https://github.com/MrDweller)

source "./load_input.sh"
source "./lib_certs.sh"
cd '../../' # Go to repository root level

# Generates all necessary certificates for the core arrowhead systems

# The environment variable PASSWORD is used to set the password of all created key stores, this variable must be set.
# The environment variable ROOT_NAME is the name of the root/master certificate. Defualts to "master".
# The environment variable CLOUD_NAME is the name of the cloud certificate. Defualts to "cloud".
# The environment variable COMPANY_NAME is the name of the company/organization. Defualts to "ltu".

# @param -s Subject alternative name parameters. Sets extra ips or dns, example: "ip:192.168.1.1". Defualts to empty string.

rm -r certificates

create_root_keystore \
    "certificates/${ROOT_NAME}.p12" "arrowhead.eu"    

create_cloud_keystore \
    "certificates/${ROOT_NAME}.p12" "arrowhead.eu" \
    "certificates/${CLOUD_NAME}.p12" "${CLOUD_NAME}.${COMPANY_NAME}.arrowhead.eu"

create_truststore \
    "certificates/truststore.p12" \
    "certificates/${ROOT_NAME}.crt" "arrowhead.eu"

create_system_keystore \
    "certificates/${ROOT_NAME}.p12" "arrowhead.eu" \
    "certificates/${CLOUD_NAME}.p12" "${CLOUD_NAME}.${COMPANY_NAME}.arrowhead.eu" \
    "certificates/sysop.p12" "sysop.${CLOUD_NAME}.${COMPANY_NAME}.arrowhead.eu" "sysop" \
    "dns:sysop,dns:localhost,ip:127.0.0.1,${SUBJECT_ALTERNATIVE_NAME}"

create_core_system_keystore() {
    SYSTEM_NAME=$1

    rm -r ${SYSTEM_NAME}/certificates

    create_system_keystore \
        "certificates/${ROOT_NAME}.p12" "arrowhead.eu" \
        "certificates/${CLOUD_NAME}.p12" "${CLOUD_NAME}.${COMPANY_NAME}.arrowhead.eu" \
        "${SYSTEM_NAME}/certificates/${SYSTEM_NAME}.p12" "${SYSTEM_NAME}.${CLOUD_NAME}.${COMPANY_NAME}.arrowhead.eu" "${SYSTEM_NAME}" \
        "dns:${SYSTEM_NAME},dns:host.docker.internal,dns:localhost,ip:127.0.0.1,${SUBJECT_ALTERNATIVE_NAME}"

    cp certificates/truststore.p12 ${SYSTEM_NAME}/certificates/truststore.p12 
}

create_core_system_keystore "authorization"
create_core_system_keystore "orchestrator"
create_core_system_keystore "serviceregistry"

###############################################################################################
### Add other core arrowhead systems here, in order to atuo generate certificates for them. ###
###############################################################################################


