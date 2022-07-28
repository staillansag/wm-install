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

The database admin user password is configured in the Docker compose yaml files. You are of course free to change these passwords.

For MS SQL:
```
        - SA_PASSWORD=Manage100!
```
For Oracle
```
        - ORACLE_PASSWORD=c1olleCtor8
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
```

Leave the part that's at the right of the semi colon unchanged (location of shared folder on the guest.)

Note: these containers are optimized for usability and not security (they're meant to be used for development activities and have a lot of ports that are exposed.)

##    Setup the database
Ensure the database container is started (webmethods1011_mssql or webmethods1011_oracle, depending on which DB you've chosen.)

In the host machine, execute the SAG database configuration tool to initialize the database.

Here's a connection example for MS SQL:
![Database configuration](https://github.com/staillansag/wm-install/blob/main/screenshots/DatabaseConfigurator.png)


##    Prepare the webmethods1011servers container for installation
Ensure the container is started and connect to it as root. You can for instance do it with Portainer.

Ensure the /opt/shared folder exists and that you see files in it (you should have exactly the same files you previously placed in the host shared folder.)
If it's empty or missing then your volume mapping in the docker compose yaml file is wrong and you need to fix it.

Create the wm user:
```
useradd wm
```

Create the following folders and change ownership to wm:
- /opt/softwareag
- /opt/softwareagupdater

```
mkdir /opt/softwareag && chown wm:wm /opt/softwareag
mkdir /opt/softwareagupdater && chown wm:wm /opt/softwareagupdater
```

Change ownership of the SAG installer and update manager and make them executable (they are two bin files in the /opt/shared folder)
```
chown wm:wm *.bin && chmod u+x /opt/shared/*.bin
```

Copy the two docker-init.sh and docker-stop.sh scripts (which are in the scripts folder of the git repo) to the root folder /, then make them executable.
```
chown wm:wm ./wm-install/scripts/*.sh && chmod u+x ./wm-install/scripts/*.sh && cp --preserve=mode,ownership ./wm-install/scripts/*.sh /
```

Install procps with this command
```
yum install -y procps
```


##    Install webMethods and the addons of your choice
Ensure the container is started and connect to with the wm user you previously created. You can for instance do it with Portainer.

Place yourself in the /opt/shared folder

Start the installation process with this command (assuming your installation image is named webmethods1011_RHELx64.zip):
```
./SoftwareAGInstaller20211015-Linux_x86_64.bin -readImage webmethods1011_RHELx64.zip -installDir /opt/softwareag -writeScript wmInstallScript
```

Assuming your installation image is similar to mine, you can also use this install script: https://github.com/staillansag/wm-install/blob/main/install/wmInstallScript

Create the UM connection factory with this command:
```
opt/softwareag/UniversalMessaging/tools/runner/runUMTool.sh CreateConnectionFactory -rname=nsp://localhost:9000 -factoryname=local_um
```

##      Start the services
Run the docker-init.sh script that you placed at the root of the server.

##      Stop the services
Run the docker-stop.sh script that you placed at the root of the server.

