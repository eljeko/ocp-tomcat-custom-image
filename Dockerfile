#registry.access.redhat.com/jboss-fuse-6/fis-java-openshift
FROM registry.access.redhat.com/jboss-webserver-3/webserver30-tomcat8-openshift

RUN mkdir -p /tmp/CUSTOMDIRTEST
RUN mkdir -p /home/jboss/customdata
ADD file.zip /home/jboss/customdata