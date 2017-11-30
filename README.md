# Custom image creation

This repo contains the files needed to create a custom version of the base image of Tomcat 8 for Openshift

## Build the image

From cli just run:

```docker build -t <name> .```

eg:

```docker build -t webserver30-tomcat8-openshift-custom .```

This command will start the build of the image


## Create OCP

oc new-build

crea una build config

# Dockerfile

You can edit your Dockerfile in order to customize your image.

In the provided example we created a text file, zipped it, and added to a specific path on the container.

# minishift

You need to be an admin user, so switch to system:admin:

```oc login -u system:admin```

Now we can create our buildconfig from the git repo:
```
bash$ oc new-build https://github.com/eljeko/ocp-tomcat-custom-image --name='webserver30-tomcat8-openshift-custom'
```
Because the repo contains a `Dockerfile` the buildconfig generated will be with Docker strategy

The output should be something like:
```
--> Found Docker image a94d005 (5 weeks old) from registry.access.redhat.com for "registry.access.redhat.com/jboss-webserver-3/webserver30-tomcat8-openshift:latest"

    JBoss Web Server 3.0
    --------------------
    Platform for building and running web applications on JBoss Web Server 3.0 - Tomcat v8

    Tags: builder, java, tomcat8

    * A Docker build using source code from https://github.com/eljeko/ocp-tomcat-custom-image will be created
      * The resulting image will be pushed to image stream "webserver30-tomcat8-openshift-custom:latest"
      * Use 'start-build' to trigger a new build

--> Creating resources with label build=webserver30-tomcat8-openshift-custom ...
    imagestream "webserver30-tomcat8-openshift-custom" created
    buildconfig "webserver30-tomcat8-openshift-custom" created
--> Success
    Build configuration "webserver30-tomcat8-openshift-custom" created and build triggered.
    Run 'oc logs -f bc/webserver30-tomcat8-openshift-custom' to stream the build progress.
```

At this point the new buildconfig triggers the builder, we can check the pod runing the build in the Openshift namespace:

```
bash$ oc get pods
NAME                                           READY     STATUS    RESTARTS   AGE
webserver30-tomcat8-openshift-custom-1-build   1/1       Running   0          1m
```

We can follow the build's log:

```
bash$ oc logs webserver30-tomcat8-openshift-custom-1-build -f
Cloning "https://github.com/eljeko/ocp-tomcat-custom-image" ...
	Commit:	a51a6a7ad0bf406ffac6e7ff6d61d0ba0dd87b94 (Build update)
	Author:	eljeko <nick.name@adomain.xyz>
	Date:	Mon Oct 2 12:41:53 2017 +0200
Pulling image registry.access.redhat.com/jboss-webserver-3/webserver30-tomcat8-openshift ...
Pulled 1/6 layers, 18% complete
Pulled 2/6 layers, 34% complete
Pulled 3/6 layers, 61% complete
Pulled 4/6 layers, 96% complete
Pulled 5/6 layers, 99% complete
Pulled 6/6 layers, 100% complete
Extracting
Warning: Pull failed, retrying in 5s ...
Step 1 : FROM registry.access.redhat.com/jboss-webserver-3/webserver30-tomcat8-openshift
 ---> a94d0056f978
Step 2 : RUN mkdir -p /tmp/CUSTOMDIRTEST
 ---> Running in 1e99872a9394
 ---> bfec452228ab
Removing intermediate container 1e99872a9394
Step 3 : RUN mkdir -p /home/jboss/customdata
 ---> Running in 7022a10b14c3
 ---> 43914d4a3f57
Removing intermediate container 7022a10b14c3
Step 4 : ADD file.zip /home/jboss/customdata
 ---> 00e389bf70f1
Removing intermediate container 292bac311d06
Step 5 : ENV "OPENSHIFT_BUILD_NAME" "webserver30-tomcat8-openshift-custom-1" "OPENSHIFT_BUILD_NAMESPACE" "openshift" "OPENSHIFT_BUILD_SOURCE" "https://github.com/eljeko/ocp-tomcat-custom-image" "OPENSHIFT_BUILD_COMMIT" "a51a6a7ad0bf406ffac6e7ff6d61d0ba0dd87b94"
 ---> Running in 210ceb343a33
 ---> 39d49d61d505
Removing intermediate container 210ceb343a33
Step 6 : LABEL "io.openshift.build.commit.id" "a51a6a7ad0bf406ffac6e7ff6d61d0ba0dd87b94" "io.openshift.build.commit.ref" "master" "io.openshift.build.commit.message" "Build update" "io.openshift.build.source-location" "https://github.com/eljeko/ocp-tomcat-custom-image" "io.openshift.build.name" "webserver30-tomcat8-openshift-custom-1" "io.openshift.build.namespace" "openshift" "io.openshift.build.commit.author" "eljeko \u003cnick.name@adomain.xyz\u003e" "io.openshift.build.commit.date" "Mon Oct 2 12:41:53 2017 +0200"
 ---> Running in c331bc9da105
 ---> fc999adec398
Removing intermediate container c331bc9da105
Successfully built fc999adec398
Pushing image 172.30.1.1:5000/openshift/webserver30-tomcat8-openshift-custom:latest ...
```

# Create a YAML for the build

You can create a YAML file from the command line above, the goal is to create a template file for builders.

```oc new-build https://github.com/eljeko/ocp-tomcat-custom-image --name='webserver30-tomcat8-openshift-custom' --dry-run -o yaml > custom-tomcat-image-build-template.yaml```