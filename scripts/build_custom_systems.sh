echo "Building custom systems..."
cd ./certificate-generation-scripts

# Add build script for your custom systems here.

# For starters you should generate a certificate for your system here, i.e
# `bash generate_system_certificate.sh -n <SYSTEM_NAME> -d <SYSTEM_CERT_DIR>`
`bash generate_system_certificate.sh -n exchangerateconsumer -d exchangerateconsumer`
