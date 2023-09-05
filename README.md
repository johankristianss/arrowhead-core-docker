# arrowhead-core
Start and run arrowhead core systems with miniamal setup and simple certificate generation.

Simple out off the box starting point for the core arrowhead components. By generating certificates at startup and running the arrowhead systems with docker. This makes it easy to use arrowhead and start development of services. This also comes with simple generation of certificates for your custom services.

This was developed from the instructions and resources from the Eclipse Arrowhead Framework [core-java-spring](https://github.com/eclipse-arrowhead/core-java-spring/tree/master).

Currently only the serviceregistry, authorization and orchestrator systems are initialized.

## Prerequisites

The system was developed with the folowing dependencies,

* Docker 24.0

Other versions should also work.

## Setup 

Clone the repository and create a `.env` file, by creating it manually or running the following command in the root location of the repository,

```
touch .env
```
In the `.env` file the following arguments can or must be added.

* `PASSWORD`, this is **REQUIRED** and will set the password for all certificates generated.
* `ROOT_NAME`, this is **OPTIONAL** and will set the name of the root certificate.
* `CLOUD_NAME`, this is **OPTIONAL** and will set the name of the cloud certificate.
* `COMPANY_NAME`, this is **OPTIONAL** and will set the name of the company in the certificates.

## Run

To start the system either run,
```
docker compose up
```
or `cd` into the `scripts` directory and run,
```
bash start.sh
```

> Note: that certificates will be generated at startup and can only be regenerated if the `certificates` directory is removed or the tag `-r` is used when running the script method. More info about scripts can be found at [scripts](/scripts/Scripts.md)

## Generate certificates for custom systems
To generate certificates for your custom systems. Add this line of code to `scripts/build_custom_systems.sh`

```
bash generate_system_certificate.sh -n <SYSTEM_NAME> -d <SYSTEM_CERT_DIR>
```

You can also run this code manually if you `cd` into `scripts/certificate-generation-scripts` and run the same command.
> Note: this option requires that the other certificates are generated and java `JRE/JDK 11`.

## Use Arrowhead
When the system is started and running, you will find the serviceregistry at [https://localhost:8443](https://localhost:8443), the authorization at [https://localhost:8445](https://localhost:8445) and the orchestrator at [https://localhost:8441](https://localhost:8441). You can also see the systems on your local ipv4 address. To access the arrowhead core system via a browser, you must add a certificate to the browser. In firefox you can follow these steps,
1. settings
2. Privacy & Security
3. scroll to Security
4. View Certificates...
5. Import...
6. Add the `sysop.p12` certificate, this must have been generated and will be located in the `certificates` directory
7. Enter the certificate password
