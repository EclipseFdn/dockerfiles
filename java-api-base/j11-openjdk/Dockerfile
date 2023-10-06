####
# This Dockerfile is used in order to build a container that runs the Quarkus application in JVM mode
#
# Based on the image provided by Quarkus in quickstarts with some modifications
####
FROM registry.access.redhat.com/ubi9/openjdk-11:1.16-1
ENV LANGUAGE='en_US:en'

# Required to patch for CVEs as base image doesn't appear to run patches
RUN microdnf upgrade -y

# We make four distinct layers so if there are application changes the library layers can be re-used
COPY --chown=1001 target/quarkus-app/lib/ /deployments/lib/
COPY --chown=1001 target/quarkus-app/*.jar /deployments/
COPY --chown=1001 target/quarkus-app/app/ /deployments/app/
COPY --chown=1001 target/quarkus-app/quarkus/ /deployments/quarkus/

EXPOSE 8080
USER 1001
ENV JAVA_OPTS="-Dquarkus.http.host=0.0.0.0 -Djava.util.logging.manager=org.jboss.logmanager.LogManager"
ENV JAVA_APP_JAR="/deployments/quarkus-run.jar"