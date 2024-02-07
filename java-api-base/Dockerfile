####
# This Dockerfile is used in order to build a container that runs the Quarkus application in JVM mode
#
# Based on the image provided by Quarkus in quickstarts with some modifications
####
ARG JDK_VERSION=11:1.16-3
FROM registry.access.redhat.com/ubi9/openjdk-${JDK_VERSION}
ENV LANGUAGE='en_US:en'

USER root
# Required to patch for CVEs as base image doesn't appear to run patches
RUN microdnf upgrade -y

EXPOSE 8080

RUN mkdir /deployments/logs && chown 185:0 /deployments/logs && chmod 775 /deployments/logs

ENV JAVA_OPTS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"
ENV JAVA_APP_JAR="/deployments/quarkus-run.jar"