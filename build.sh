bash stop.sh
echo "Building arrowhead.."

echo "Generating certificates..."
cd ./certificate-generation-scripts
bash generate_core_certificates.sh
cd ../
bash build_custom_systems.sh