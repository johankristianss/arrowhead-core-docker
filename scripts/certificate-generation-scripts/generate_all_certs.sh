#!/bin/bash

# import libs
source "./lib_certs.sh"

# get to root level
cd "../../"

# INPUTS
PASSWORD="123456"
ROOT_NAME="master"
# we make certs for 2 clouds
CLOUD_NAME="c1 c2"
COMPANY_NAME="ltu"

# these arguments are (in order): name of the cloud that we are making our systems for
# the system name (that will be used for the DNS)
# system ip (the ip of the system)
create_single_system_keystore() {
    C_NAME=$1
    SYSTEM_NAME=$2
    SYSTEM_IP=$3

    create_system_keystore \
        "certificates/${ROOT_NAME}.p12" "arrowhead.eu" \
        "certificates/${C_NAME}.p12" "${C_NAME}.${COMPANY_NAME}.arrowhead.eu" \
        "${SYSTEM_NAME}/certificates/${SYSTEM_NAME}.p12" "${SYSTEM_NAME}.${C_NAME}.${COMPANY_NAME}.arrowhead.eu" "${SYSTEM_NAME}" \
        "dns:${SYSTEM_NAME},dns:${SYSTEM_IP},dns:localhost,ip:127.0.0.1,${SUBJECT_ALTERNATIVE_NAME}"

    cp certificates/truststore.p12 ${SYSTEM_NAME}/certificates/truststore.p12 
}

for cloud_name in $CLOUD_NAME; do
    mkdir "${cloud_name}"
    cd "${cloud_name}"
    mkdir "certificates"

    # create cloud root keystore
    create_root_keystore \
        "./certificates/${ROOT_NAME}.p12" "arrowhead.eu"    

    # create the cloud keystore
    create_cloud_keystore \
        "certificates/${ROOT_NAME}.p12" "arrowhead.eu" \
        "certificates/${cloud_name}.p12" "${cloud_name}.${COMPANY_NAME}.arrowhead.eu"

    # create the cloud truststore
    create_truststore \
        "certificates/truststore.p12" \
        "certificates/${ROOT_NAME}.crt" "arrowhead.eu"

    # create sysop for the cloud
    create_system_keystore \
        "certificates/${ROOT_NAME}.p12" "arrowhead.eu" \
        "certificates/${cloud_name}.p12" "${cloud_name}.${COMPANY_NAME}.arrowhead.eu" \
        "certificates/sysop.p12" "sysop.${cloud_name}.${COMPANY_NAME}.arrowhead.eu" "sysop" \
        "dns:sysop,dns:localhost,ip:127.0.0.1,ip:172.17.0.1"

    # create all the core systems we want
    create_single_system_keystore "${cloud_name}" "authorization" "${cloud_name}-authorization"
    create_single_system_keystore "${cloud_name}" "orchestrator" "${cloud_name}-orchestrator"
    create_single_system_keystore "${cloud_name}" "serviceregistry" "${cloud_name}-serviceregistry"
    create_single_system_keystore "${cloud_name}" "eventhandler" "${cloud_name}-eventhandler"
    create_single_system_keystore "${cloud_name}" "gateway" "${cloud_name}-gateway"
    create_single_system_keystore "${cloud_name}" "gatekeeper" "${cloud_name}-gatekeeper"

    # create all produers/consumers for the given cloud to test demo-car in cloud 1 and demo-exchange-rate-intercloud
    # this is hardcoded and stupid so good luck
    if [[ "$cloud_name" == "c1" ]]; then
        # demo-car provider and consumer
        create_single_system_keystore "${cloud_name}" "cardemoprovider" "cardemoprovider"
        create_single_system_keystore "${cloud_name}" "cardemoconsumer" "cardemoconsumer"

        # consumer for demo-exchange-rate-intercloud-consumer
        create_single_system_keystore "${cloud_name}" "exchangerateconsumer" "exchangerateconsumer"
    fi

    if [[ "$cloud_name" == "c2" ]]; then
        # provider for demo-exchange-rate-intercloud-provider
        create_single_system_keystore "${cloud_name}" "exchangerateprovider" "exchangerateprovider"
    fi
    cd "../"

done

