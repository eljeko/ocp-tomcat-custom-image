# Custom image creation

This repo contains the files needed to create a custom version of the base image of Tomcat 8 for Openshift

## Build the image

From cli just run:

```docker build -t <name> .```

eg:

```docker build -t webserver30-tomcat8-openshift-custom .```

This command will start the build of the image


## Create OCP 
