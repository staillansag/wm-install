# Running webMethods on Docker

##    Create the installation image
Run the SAG installer on your host to create an image for your webMethods installation.

Go to advanced options / Image and use these settings:

![Create Image](https://github.com/staillansag/wm-install/blob/main/screenshots/AdvancedOptions_CreateImage.png)

##    Setup Docker on the host machine
Configure Docker resources to allow (if possible) 4 vCPUs and 8 Gb RAM. It may work with less resources, but I haven't tested it.
Ensure docker-compose is installed on your host. if not, go to https://docs.docker.com/compose/install/

##    Install and configure Portainer
it's not strictly required, but it makes the management of Docker assets a lot easier.
See https://www.portainer.io

##    Create a folder in the host for shared assets
This folder will allow us to share data between the host machine and the Docker containers.
In what follows we use /opt/shared

##    Add content to the shared folder
Clone the git repo and place its content in the shared folder.
Also place in the shared folder:
- the zipped webMethods installation image (which you created earlier)
- the SAG installer for your guest OS: take the one for the Linux x64 OS
- the SAG updater for your guest OS: take the one for the Linux x64 OS
- the license files

##    Create the Docker containers
We start with the database.
We provide docker compose files for Oracle XE and MS SQL here, choose one of these and create the container:
- docker-compose-webmethods1011-mssql.yml
- docker-compose-webmethods1011-oracle.yml

```
docker-compose -f docker-compose-webmethods1011-mssql.yml up -d
```

or

```
docker-compose -f docker-compose-webmethods1011-oracle.yml up -d
```

Then we create the Linux guest image using this docker compose file: docker-compose-webmethods1011-servers.yml.

This container uses a volume that maps the shared folder on the host and the shared folder on the guest:
```
      volumes:
        - /opt/shared:/opt/shared
```

If you've chosen another location than /opt/shared for your shared folder on the host, make sure to update the path (the part that's at the left of the semi colon.)

```
docker-compose -f docker-compose-webmethods1011-servers.yml up -d


Leave the part that's at the right of the semi colon unchanged (location of shared folder on the guest.)

Note: these containers are optimized for usability and not security (they're meant to be used for development activities and have a lot of ports that are exposed.)

##    Setup the database
Ensure the database container is started (webmethods1011_mssql or webmethods1011_oracle, depending on which DB you've chosen.)

In the host machine, execute the SAG database configuration tool to initialize the database.

##    Prepare the webmethods1011servers container for installation
Ensure the container is started and connect to it as root. You can for instance do it with Portainer.

Ensure the /opt/shared folder exists and that you see files in it (you should have exactly the same files you previously placed in the host shared folder.)
If it's empty or missing then your volume mapping in the docker compose yaml file is wrong and you need to fix it.

Create the wm user.

Create the following folders:
- /opt/softwareag
- /opt/softwareagupdater
Make wm the owner of these folders

Install props with this command
```
yum install -y procps
```

Make the SAG installer and update manager executable for the wm user (they are in the /opt/shared folder)

Copy the two docker-init.sh and docker-stop.sh scripts (which are in the scripts folder of the git repo) to the root folder /, then make them executable.

##    Install webMethods and the addons of your choice
Ensure the container is started and connect to with the wm user you previously created. You can for instance do it with Portainer.

