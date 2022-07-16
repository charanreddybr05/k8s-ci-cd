FROM tomcat AS tomcat
COPY target/wwp-1.0.0.war /usr/local/tomcat/webapps/wwp-1.0.0.war
EXPOSE 8080

FROM kiwigrid/gcloud-kubectl-helm