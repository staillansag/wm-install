# Running webMethods on Docker

##  Setup Docker on the host machine
Configure Docker resources to allow (if possible) 4 vCPUs and 8 Gb RAM. It may work with less resources, but I haven't tested it.

## Create a folder in the host for shared assets
This folder will allow us to share data between the host machine and the Docker containers.
In what follows we use /opt/shared
