# Running webMethods on Docker

##  Setup Docker on the host machine
Configure Docker resources to allow (if possible) 4 vCPUs and 8 Gb RAM. It may work with less resources, but I haven't tested it.
Ensure docker-compose is installed on your host. if not, go to https://docs.docker.com/compose/install/

##  Install and configure Portainer
it's not strictly required, but it makes the management of Docker assets a lot easier.
See https://www.portainer.io

##  Create a folder in the host for shared assets
This folder will allow us to share data between the host machine and the Docker containers.
In what follows we use /opt/shared

##  Add content to the shared folder
Clone the git repo and place its content in the shared folder.
Also place in the shared folder:
- the SAG installer and updater (for Linux x86_64)
- the license files

##  Create the Docker containers
We start with the database.
We provide docker compose files for Oracle XE and MS SQL here, choose one of these and create the container:
- docker-compose-webmethods1011-mssql.yml
- docker-compose-webmethods1011-oracle.yml

Then we create the Linux guest image using this docker compose file: docker-compose-webmethods1011-servers.yml

Note: these containers are optimized for usability and not security (they're meant to be used for development activities and have a lot of ports that are exposed.)
