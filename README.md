# arrowhead-core
This repository includes a `docker-compose.yaml` file used to start two arrowhead clouds, together with an activemq server, to facilitate intercloud communication.

This repository is based on [arrowhead-core](https://github.com/MrDweller/arrowhead-core/), with quite a few modifications as here we are only interested in the creation of the clouds in docker. There is no longer any automatic certification generation when starting up the core systems, however, the certificate generation scripts are still available. Please refer to the repo from which this repo was forked for documentation of certificate generation.

This was developed from the instructions and resources from the Eclipse Arrowhead Framework [core-java-spring](https://github.com/eclipse-arrowhead/core-java-spring/tree/master).

The core systems which are initiated in each cloud: authorization, event handler, gatekeeper, gateway, orchestrator, and service registry. Currently, there is no transport layer security for the connection through the broker.

## Prerequisites
The system was developed on the following setup:

* Ubuntu 22.04.5 LTS
* Docker 27.0

The `docker-compose` will probably work on other systems however it has not been tested.

## Setup 
Clone the repository and create a `.env` file, by creating it manually or running the following command in the root location of the repository:

```
touch .env
```

In the `.env` file the following arguments can or must be added.

* `PASSWORD`, this is **REQUIRED**. This will be the password used for all the certificates. If u want to generate certificates this will set the password for all certificates generated.
* `ROOT_NAME`, this is **OPTIONAL**. If u want to generate certificates this will set the name of the root certificate.
* `CLOUD_NAME`, this is **OPTIONAL**. If u want to generate certificates this will set the name of the cloud certificate.
* `COMPANY_NAME`, this is **OPTIONAL**. If u want to generate certificates this will set the name of the company in the certificates.

Secondly, for development purposes, we set the same DNS names on the host as they are inside the docker containers as consumers/producers are usually developed locally before being deployed inside docker containers. These names need to be the same as the name as the docker containers as that is how docker does communication between containers. This is achieved by editing (on Unix-based systems) `/etc/hosts` and adding:

```
127.0.0.1 c1-gatekeeper
127.0.0.1 c1-eventhandler
127.0.0.1 c2-authorization
127.0.0.1 c1-authorization
127.0.0.1 c2-gatekeeper
127.0.0.1 c1-serviceregistry
127.0.0.1 c2-serviceregistry
127.0.0.1 c1-orchestrator
127.0.0.1 c2-gateway
127.0.0.1 c2-orchestrator
127.0.0.1 c2-eventhandler
127.0.0.1 c1-gateway
127.0.0.1 broker-activemq
127.0.0.1 c2-database
127.0.0.1 c1-database
127.0.0.1 172.17.0.1
```

If not on a Unix-based system, you need to figure out how to do it.

Furthermore, on linux systems in order to access the host from inside a docker container there is a static ip that can be used `172.17.0.1`. On other systems you might have to change something in order to be able to access the underlying host from inside a docker container (required for letting the gateway in the consumer cloud being able to return the created tunnel).

You need to generate certificates for every single system in the clouds, but not for the activemq server. This can be done any way you would like. These certs need to be placed correctly in each individual directory in order to `cp` it correctly into the docker containers on startup. These paths are defined inside the `docker-compose.yaml` file. For example: 

```
volumes:
   - ./c1/serviceregistry/application.properties:/opt/arrowhead/application.properties
   - ./c1/serviceregistry/certificates:/opt/arrowhead/certificates
```

i.e. for the cloud1 service registry the certificates have to be in the path of `./c1/serviceregistry/certificates`.

Lastly, if you want to change anything that has to do with any of the core systems please refer to the `application.properties` files for the corresponding systems.

## Run
To start the containers, `cd` to the root folder and run:
```
docker compose up
```

After all the containers are running, you need to set up the rules for the intercloud communication.
See [This](https://github.com/eclipse-arrowhead/core-java-spring/blob/master/documentation/gatekeeper/GatekeeperSetup.md#3-adding-relay) and below for this.

## Generate certificates for custom systems
Refer to [arrowhead-core](https://github.com/MrDweller/arrowhead-core/), create the certificates yourself, or use the [arrowhead certificate generator](https://github.com/eclipse-arrowhead/core-java-spring/wiki/Certificate-Creation).

## Testing
Once the clouds are running and the intercloud rules have been setup you can test the setup by using: [this](https://github.com/arrowhead-f/sos-examples-spring/tree/master/demo-exchange-rate-intercloud).

Remember to set up the inter-cloud authorization rules.
